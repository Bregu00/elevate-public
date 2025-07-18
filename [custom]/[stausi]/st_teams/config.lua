Config = Config or {}

-- Which key to open teams menu?
-- Find the different keys in here: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.OpensTeams = "F10"

-- The total length of a team name
Config.MaxNameLength = 20

-- The total amount of Members in a Team
Config.MaxMembers = 16

-- The max invite distance between 2 players.
Config.InviteDistance = 30.0

-- Translation. Remember to not replace or remove the %s

Config.UITranslate = {
    ["Header1"] = "Manage your team",
    ["Header2"] = "Create your own team for jobs, etc.",

    ["Create"] = "Create",
    ["Cancel"] = "Cancel",
    ["Error"] = "Error",

    ["TeamName"] = "Name of the Team",
    ["TeamNamePlaceholder"] = "Write the name of the Team...",

    ["CreateTeam"] = "Create Team",
    ["Invites"] = "Invites",
    ["TeamHub"] = "Team Hub",

    ["NoTeam"] = "You are not a part of a team!",
    ["TeamTooBig"] = "The team is too big! Max:",

    ["YourInvites"] = "Your Invites",
    ["AcceptInvite"] = "Accept Invite",
    ["DeclineInvite"] = "Decline Invite",

    ["OpenTeams"] = "Open Teams",
    ["JoinTeam"] = "Join Team",

    ["DeleteTeam"] = "Delete Team",
    ["LeaveTeam"] = "Leave Team",
    ["ChangeName"] = "Change Name",

    ["CloseTeam"] = "Close Team",
    ["OpenTeam"] = "Open Team",

    ["AddPlayer"] = "Add Player",
    ["Invite"] = "Invite",
    ["RemoveInvite"] = "Remove Invite",

    ["Members"] = "Members",
    ["Kick"] = "Kick",
    ["MakeLeader"] = "Make Leader",
}

Config.Error = "Error"
Config.Success = "Success"

Config.Open = "opened"
Config.Closed = "closed"
Config.TeamPublic = "%s is now %s"

Config.DeleteTeam = "You have deleted %s"

Config.NotInATeam = "You are not in a team"
Config.InATeam = "You are already in a team"
Config.NoInvite = "You don't have an invite from this team"
Config.TeamNameTooLong = "The name of your team is too long."

Config.NeedNumber = "You have to write an number"
Config.CouldNotFindPlayer = "Could not find player with ID %s"
Config.PlayerNotClose = "%s is too far away"

Config.MaxMembersInTeam = "The team has achieved maximum members"
Config.NotOwnerOfTeam = "You are not the owner of %s"

Config.UserAlreadyInTeam = "%s is already in a team"
Config.UserAlreadyInYourTeam = "%s is already in your team"

Config.TeamDoesNotExist = "This Team does not exist anymore"
Config.UserIsNotInTeam = "%s is not a member of your team"

Config.YouHaveBeenInvited = "You have been invited to %s"
Config.UserHasDeclinedInvite = "%s has declined your invite"

Config.JoinedTeam = "You have joined %s"
Config.UserJoinedTeam = "%s has joined your team"

Config.InviteSend = "%s has been invited to %s"
Config.InviteRevoked = "You have removed the invite from %s"

Config.InviteAccepted = "You have accepted an invite from %s"
Config.InviteDeclinded = "You have declined an invite from %s"
Config.InviteUserDeclined = "%s has declined your invite"

Config.UserAdded = "%s is added to %s"
Config.YouHaveBeenAdded = "You have been added to %s"

Config.UserRemoved = "%s is removed from %s"
Config.YouHaveBeenRemoved = "You have been removed from %s"
Config.LeftTeam = "You have left the team %s"

Config.BecomeLeader = "You have become the leader of %s"
Config.GrantedLeadership = "You have granted leadershop to %s"
Config.ChangedName = "You have changed the name to %s"
