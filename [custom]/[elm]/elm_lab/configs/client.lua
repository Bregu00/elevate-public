ConfigClient = {
    Bander = {
    },
    Shells = {
        ["coke"] = { -- navn på shell
            obj = `shell_coke2`, -- object
            door = vector3(-6.326637, 8.692626, -3.948425),
            pak = vector3(5.966624, -2.645793, -3.948586),
            process = vector3(0.560538, -0.610579, -3.948593),
            kemi_inv = vector3(-8.020508, -1.028992, -3.948639),
        },
        ["weed"] = {
            obj = `shell_weed2`,
            door = vector3(17.883699, 11.702231, -5.086906),
            farm = vector3(6.339082, -9.652211, -5.082878),
            process = vector3(-14.414850, -8.253390, -4.100212),
            kemi_inv = vector3(-4.018799, -3.748444, -4.078094),
            pak = vector3(-14.369535, -12.415459, -4.098511)
        },
        ["meth"] = {
            obj = `shell_meth`,
            door = vector3(-6.233685, 8.586979, -3.948586),
            process = vector3(-2.282414, -1.639908, -3.462875),
            kemi_inv = vector3(-8.034912, 1.450928, -3.948334),
            pak = vector3(4.627119, -2.754667, -3.948425),
        },
        ["heroin"] = {
            obj = `shell_meth`,
            door = vector3(-6.233685, 8.586979, -3.948586),
            process = vector3(-2.282414, -1.639908, -3.462875),
            kemi_inv = vector3(-8.034912, 1.450928, -3.948334),
            pak = vector3(4.627119, -2.754667, -3.948425),
        },
    },
    processtid = 2000, -- 1000 = 1 sekund
    farmtid = 1000, -- 1000 = 1 sekund
    packtid = 1000, -- 1000 = 1 sekund
    Notifikationer = {
        Forkertkode = false,
        IkkePoliti = false,
        IkkeBande = false
    }
}