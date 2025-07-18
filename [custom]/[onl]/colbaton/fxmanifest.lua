fx_version 'cerulean'
game 'gta5'

description 'Telescopic Baton'
version '1.2'

files {
    'dlctext.meta',
	'audio/colbaton_game.dat151.rel',
	'audio/colbaton_sounds.dat54.rel',
    'pickups.meta',
    'contentunlocks.meta',
    'shop_weapon.meta',
    'weaponarchetypes.meta',
	'weaponcomponents.meta',
    'weaponanimations.meta',
    'pedpersonality.meta',
	'weapon_colbaton.meta',
    'clip_sets.xml'
}

data_file 'TEXTFILE_METAFILE' 'dlctext.meta'
data_file 'AUDIO_GAMEDATA' 'audio/colbaton_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audio/colbaton_sounds.dat'
data_file 'DLC_WEAPON_PICKUPS' 'pickups.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'contentunlocks.meta'
data_file 'WEAPON_SHOP_INFO_METADATA_FILE' 'shop_weapon.meta'
data_file 'WEAPON_METADATA_FILE' 'weaponarchetypes.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' 'weaponcomponents.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'weapon_colbaton.meta'
data_file 'CLIP_SETS_FILE' 'clip_sets.xml'

client_script 'names.lua'
