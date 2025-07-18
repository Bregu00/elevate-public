var uiopen = false;
let myTimeout = undefined;
let LANG = [];

function formatMoney(amount) {
    // Format money according to Danish conventions without decimal places
    return new Intl.NumberFormat('da-DK', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount);
}

function openbankui(clientdata) {
    if (!uiopen) {
        uiopen = true;
        $('#app').fadeIn('slow');
        $('#player-name').html(clientdata.playername);
        $('#wallet-balance').html(LANG["walletui"] + " : " + formatMoney(clientdata.nakit) + " DKK");
        
        // Update card number
        $('#card-number').html(clientdata.iban);

        // Update account balance
        $('#account-balance').html(formatMoney(clientdata.bankapara) + " DKK");

        // Clear existing history first
        $('#historydetail').html("");
        
        // Check if we have history data
        if (clientdata.history != undefined && clientdata.history != null && clientdata.history.length > 0) {
            // Make a copy and reverse to show newest first
            let historyData = [...clientdata.history].reverse();
            
            // Display up to 8 transactions
            for (let i = 0; i < Math.min(historyData.length, 8); i++) {
                let v = historyData[i];
                let htmlItem = "";
                
                if (v.type == "withdraw") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon withdraw-tx">
                                <i class="fas fa-arrow-down"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-withdraw"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-negative">-${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "deposit") {    
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon deposit-tx">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-deposit"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-positive">+${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "cometransfer") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon transfer-tx">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-come-transfer"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-positive">+${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "sendtransfer") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon transfer-tx">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-send-transfer"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-negative">-${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                }
                
                $("#historydetail").append(htmlItem);
            }
        } else {
            // Display a message if no transactions are available
            $("#historydetail").html(`
                <div class="no-transactions">
                    <i class="fas fa-info-circle"></i>
                    <p>Ingen seneste transaktioner</p>
                </div>
            `);
        }
        
        // Request transaction history update from the server
        $.post('https://wert-banking/requestHistory', JSON.stringify({}));
    }
}

function closebankui(post) {
    uiopen = false;
    $('#app').css('display', 'none');
    $('#bank-withdraw-amount').val("");
    $('#bank-deposit-amount').val("");
    $('#bank-id-amount').val("");
    $('#bank-send-amount').val("");
    if (post) {
        $.post('https://wert-banking/Close', JSON.stringify({}));
    }
}

function updateui(updatedata) {
    $('#wallet-balance').html(LANG["walletui"] + " : " + formatMoney(updatedata.nakit) + " DKK");
    $('#account-balance').html(formatMoney(updatedata.bankapara) + " DKK");

    if (updatedata.history != undefined && updatedata.history != null) {
        $('#historydetail').html("");
        updatedata.history.reverse();
        
        $.each(updatedata.history, function(k, v){
            if (k < 8) {
                let htmlItem = "";
                if (v.type == "withdraw") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon withdraw-tx">
                                <i class="fas fa-arrow-down"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-withdraw"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-negative">-${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "deposit") {    
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon deposit-tx">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-deposit"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-positive">+${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "cometransfer") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon transfer-tx">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-come-transfer"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-positive">+${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                } else if (v.type == "sendtransfer") {
                    htmlItem = `
                        <div class="transaction-item">
                            <div class="transaction-icon transfer-tx">
                                <i class="fas fa-exchange-alt"></i>
                            </div>
                            <div class="transaction-details">
                                <div class="transaction-type">${LANG["history-send-transfer"]}</div>
                                <div class="transaction-date">${v.date}</div>
                            </div>
                            <div class="transaction-amount amount-negative">-${formatMoney(v.amount)} DKK</div>
                        </div>
                    `;
                }
                $("#historydetail").append(htmlItem);
            }
        });
    }
}

function WertNotif(icon, text, color, time) {
    if (time == null || time == undefined) {
        time = 2500;
    }
    if (myTimeout != undefined) {
        $('.notification').css('display', 'none');
        clearTimeout(myTimeout);
        myTimeout = undefined;
    }
    
    // Update notification class based on color
    $('.notification').removeClass('error success');
    if (color === "#c0392b" || color === "#e74c3c") {
        $('.notification').addClass('error');
    } else if (color === "#26c926" || color === "#00b894") {
        $('.notification').addClass('success');
    }
    
    // Set icon and message
    $('.notification-icon').attr('class', 'notification-icon ' + icon);
    $('.notification-message').text(text);
    
    // Show notification
    $('.notification').fadeIn('fast').css('display', 'flex');
    
    myTimeout = setTimeout(function() {
        $('.notification').fadeOut('fast');
        myTimeout = undefined;
    }, time);
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            closebankui(true);
            break;
    }
});

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "Open":
                LANG = event.data.lang;
                openbankui(event.data.data);
                break;
            case "Close":
                closebankui(false);
                break;
            case "Update":
                updateui(event.data.update);
                break;
            case "Notif":
                WertNotif(event.data.icon, event.data.text, event.data.color, event.data.time);
                break;
        }
    });
    
    // Make sure the deposit-all button has the correct class
    $('#deposit-all').addClass('hepsiniyatir');
});

$(document).on('click', '#exit', function(event){
    event.preventDefault();
    closebankui(true);
});

// Quick withdraw buttons
$(document).on('click', '#hizlicek', function(event){
    event.preventDefault();
    let datamiktar = $(this).data('miktar');
    if (datamiktar) {
        var cekilecekmiktar = 1000;
        if (datamiktar == "10000") {
            cekilecekmiktar = 10000;
        } else if (datamiktar == "100000") {
            cekilecekmiktar = 100000;
        } else if (datamiktar == "1000000") {
            cekilecekmiktar = 1000000;
        }
        $.post('https://wert-banking/paracek', JSON.stringify({
            amount: cekilecekmiktar
        }));
    }
});

// Quick deposit buttons
$(document).on('click', '#hizliyatir', function(event){
    event.preventDefault();
    let datamiktar = $(this).data('miktar');
    if (datamiktar) {
        var yatirmiktar = 1000;
        if (datamiktar == "10000") {
            yatirmiktar = 10000;
        } else if (datamiktar == "100000") {
            yatirmiktar = 100000;
        } else if (datamiktar == "1000000") {
            yatirmiktar = 1000000;
        }
        $.post('https://wert-banking/parayatir', JSON.stringify({
            amount: yatirmiktar
        }));
    }
});

// Deposit all money
$(document).on('click', '.hepsiniyatir', function(event){
    event.preventDefault();
    $.post('https://wert-banking/allpara', JSON.stringify({}));
});

// Deposit form submission
$(document).on('click', '#withdraw', function(event){
    event.preventDefault();
    var withdrawamount = $("#bank-withdraw-amount").val();
    if (withdrawamount != "") {
        if (withdrawamount > 0) {
            $('#bank-withdraw-amount').val("");
            $.post('https://wert-banking/parayatir', JSON.stringify({
                amount: withdrawamount
            }));
        } else {
            WertNotif("fa-solid fa-square-xmark", LANG["zerovalue-error"], "#c0392b", 2500);
        }
    } else {
        WertNotif("fa-solid fa-square-xmark", LANG["invalid-value"], "#c0392b", 2500);
    }
});

// Withdraw form submission
$(document).on('click', '#deposit', function(event){
    event.preventDefault();
    var depositamount = $("#bank-deposit-amount").val();
    if (depositamount != "") {
        if (depositamount > 0) {
            $('#bank-deposit-amount').val("");
            $.post('https://wert-banking/paracek', JSON.stringify({
                amount: depositamount
            }));
        } else {
            WertNotif("fa-solid fa-square-xmark", LANG["zerovalue-error"], "#c0392b", 2500);
        }
    } else {
        WertNotif("fa-solid fa-square-xmark", LANG["invalid-value"], "#c0392b", 2500);
    }
});

// Transfer money
$(document).on('click', '#sendmoney', function(event){
    event.preventDefault();
    var playerid = $("#bank-id-amount").val();

    if (playerid != "" && playerid > 0) {
        var sendamount = $("#bank-send-amount").val();

        if (sendamount != "" && sendamount > 0) {
            $('#bank-id-amount').val("");
            $('#bank-send-amount').val("");
            $.post('https://wert-banking/parasend', JSON.stringify({
                id: playerid,
                amount: sendamount
            }));
        } else {
            WertNotif("fa-solid fa-square-xmark", LANG["invalid-value"], "#c0392b", 2500);
        }
    } else {
        WertNotif("fa-solid fa-square-xmark", LANG["invalid-value"], "#c0392b", 2500);
    }
});