Queries = {
    ["check_dna"] = {
        ["qb"] = [[
            SELECT IF(p.citizenid = NULL,  "UNKNOWN", CONCAT(JSON_VALUE(p.charinfo, "$.firstname"), " ", JSON_VALUE(p.charinfo, "$.lastname"))) as name FROM players p 
            LEFT JOIN snipe_evidence_identifiers sei ON p.citizenid = sei.identifier
            WHERE sei.dna = @dna AND sei.is_taken = 1
        ]],
        ["esx"] = [[
            SELECT IF(u.identifier = NULL, "UNKNOWN", CONCAT(firstname, lastname)) as name FROM users u 
            LEFT JOIN snipe_evidence_identifiers sei ON u.identifier = sei.identifier
            WHERE sei.dna = @dna AND sei.is_taken = 1
        ]]
    },
    ["check_fingerprint"] = {
        ["qb"] = [[
            SELECT IF(p.citizenid = NULL, "UNKNOWN", CONCAT(JSON_VALUE(p.charinfo, "$.firstname"), " ", JSON_VALUE(p.charinfo, "$.lastname"))) as name FROM players p 
            LEFT JOIN snipe_evidence_identifiers sei ON p.citizenid = sei.identifier
            WHERE sei.fingerprint = @fingerprint AND sei.is_taken = 1
        ]],
        ["esx"] = [[
            SELECT IF(u.identifier = NULL, "UNKNOWN", CONCAT(firstname, lastname)) as name FROM users u 
            LEFT JOIN snipe_evidence_identifiers sei ON u.identifier = sei.identifier
            WHERE sei.fingerprint = @fingerprint AND sei.is_taken = 1
        ]]
    }
}