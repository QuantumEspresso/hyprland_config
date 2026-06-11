local profiles = {
    laptop = {
        primary = "InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x057D",
        monitors = {
            {
                desc = "InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x057D",
                mode = "1920x1080@60.01000",
                position = "0x0",
                scale = 1.2,
            }
        }
    },

    dock = {
        primary = "ASUSTek COMPUTER INC ASUS MB14AHD S6LMTF011157",
        monitors = {
            {
                desc = "ASUSTek COMPUTER INC ASUS MB14AHD S6LMTF011157",
                mode = "1920x1080@60",
                position = "2800x1350",
                scale = 1.20
            },
            {
                desc = "Lenovo Group Limited P40w-20 V909507G",
                mode = "5120x2160@74",
                position = "0x0",
                scale = 1.60
            }
        }
    },

    triple = {
        primary = "Lenovo Group Limited P40w-20 V909507G",
        monitors = {
            {
                desc = "Lenovo Group Limited P40w-20 V909507G",
                mode = "5120x2160@75",
                position = "0x0",
                scale = 1.6,
            },
            {
                desc = "ASUSTek COMPUTER INC ASUS MB14AHD S6LMTF011157",
                mode = "1920x1080@60.01000",
                position = "2800x1350",
                scale = 1.2,
            },
            {
                desc = "InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x057D",
                disabled = true,
            },
        }
    },
}

return profiles
