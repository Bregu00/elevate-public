$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function(event) {
    if (event.data.action == 'open') {
      var type        = event.data.type;
      var userData    = event.data.array['user'][0];
      var licenseData = event.data.array['licenses'];
      var sex         = userData.sex;

      $('img').show();
      $('#name').css('color', '#282828');

      if (sex.toLowerCase() == 'm') {
        $('img').attr('src', 'assets/images/male.png');
        $('#sex').text('MAND');
      } else {
        $('img').attr('src', 'assets/images/female.png');
        $('#sex').text('KVINDE');
      }

      $('#name').text(userData.firstname + ' ' + userData.lastname);
      $('#dob').text(userData.dateofbirth);
      $('#height').text(userData.height);
      $('#signature').text(userData.firstname + ' ' + userData.lastname);

      if (licenseData != null) {
        Object.keys(licenseData).forEach(function(key) {
          var licenseType = licenseData[key].type;

          if (licenseType == 'drive_bike') {
            licenseType = 'motorcykel';
          } else if (licenseType == 'drive_truck') {
            licenseType = 'lastbil';
          } else if (licenseType == 'drive') {
            licenseType = 'bil';
          }

          if (licenseType == 'motorcykel' || licenseType == 'lastbil' || licenseType == 'bil') {
            $('#licenses').append('<p>' + licenseType + '</p>');
          }
        });
      }

      if (type == 'driver') {
        $('#id-card').css('background', 'url(assets/images/license.png)');
      } else if (type == 'weapon') {
        $('img').hide();
        $('#name').css('color', '#d9d9d9');
        $('#id-card').css('background', 'url(assets/images/firearm.png)');
      } else {
        $('#id-card').css('background', 'url(assets/images/idcard.png)');
      }

      $('#id-card').show();
    } else if (event.data.action == 'close') {
      $('#name').text('');
      $('#dob').text('');
      $('#height').text('');
      $('#signature').text('');
      $('#sex').text('');
      $('#id-card').hide();
      $('#licenses').html('');
    }
  });
});