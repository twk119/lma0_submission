import unittest
from checks import *

def split_inst(string):
    return string.strip('\n').split(" ")

class TestCheck(unittest.TestCase):
    def test_check_r(self):
        self.assertEqual(check_r(split_inst("ADD GP2 GP1 C0")), int("000A",16))
        self.assertEqual(check_r(split_inst("SUB GP2 GP1 C1")), int("028A",16))
        self.assertEqual(check_r(split_inst("MOV GP2 GP1 CC")), int("058A",16))
        self.assertEqual(check_r(split_inst("XSR GP1 GP1 CMSB")), int("0709",16))
        self.assertEqual(check_r(split_inst("LDR GP3 GP2")), int("0A13",16))
        self.assertEqual(check_r(split_inst("STR GP1 GP2")), int("0C11",16))
        self.assertEqual(check_r(split_inst("LDR GP2 GP1 1")), int("0A4A",16))
        self.assertEqual(check_r(split_inst("STR GP2 GP1 2")), int("0C8A",16))
        self.assertEqual(check_r(split_inst("LCG16")), int("0980",16))
        self.assertEqual(check_r(split_inst("LCG32")), int("09C0",16))
        self.assertEqual(check_r(split_inst("MAC16")), int("0900",16))
        self.assertEqual(check_r(split_inst("MAC32")), int("0940",16))
        self.assertEqual(check_r(split_inst("MUL16")), int("0800",16))
        self.assertEqual(check_r(split_inst("MUL32")), int("0840",16))
        self.assertEqual(check_r(split_inst("POW16")), int("0880",16))
        self.assertEqual(check_r(split_inst("POW32")), int("08C0",16))
        self.assertEqual(check_r(split_inst("NOT GP4")), int("0E04",16))
        self.assertEqual(check_r(split_inst("AND GP3 GP1")), int("0F0B",16))
        self.assertEqual(check_r(split_inst("OR GP2 GP5")), int("0EAA",16))
        self.assertEqual(check_r(split_inst("XOR GP1 GP1")), int("0F89",16))

    def test_check_i(self):
        self.assertEqual(check_i(split_inst("ADDI GP1 0x45")), int("1229",16))
        self.assertEqual(check_i(split_inst("SUBI GP1 0x45")), int("1629",16))
        self.assertEqual(check_i(split_inst("LDI GP1 0x20")), int("1901",16))
        self.assertEqual(check_i(split_inst("LDI GP5 -1")), int("1BFD",16))

    def test_check_ls(self):
        self.assertEqual(check_ls(split_inst("LDA GP1 0x800")), int("4001",16))
        self.assertEqual(check_ls(split_inst("STA GP1 0x800")), int("6001",16))
        with self.assertRaises(AssertionError):
            check_ls(split_inst("STA GP5 0x01"))

    def test_check_j(self):
        self.assertEqual(check_j(split_inst("JMP 0x3")), int("800C",16))
        self.assertEqual(check_j(split_inst("JEQ GP3 0x03")), int("800F",16))
        self.assertEqual(check_j(split_inst("JLT GP3 0x08")), int("A023",16))
        self.assertEqual(check_j(split_inst("JAL 0x20")), int("C080",16))
        self.assertEqual(check_j(split_inst("JR RA")), int("E000",16))
        with self.assertRaises(AssertionError):
            check_j(split_inst("JEQ GP5 0x01"))



if __name__ == "__main__":
    unittest.main()