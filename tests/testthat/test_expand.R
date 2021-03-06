test_that("Some simple test cases", {
    expect_equal(expand_braces("{x,y}{a,b}", engine = "r"),
                 c("xa", "xb", "ya", "yb"))
    expect_equal(expand_braces("a{2..4}", engine = "r"),
                 c("a2", "a3", "a4"))
    expect_equal(expand_braces("{a..d}4", engine = "r"),
                 c("a4", "b4", "c4", "d4"))
    expect_equal(expand_braces("{C..F}", engine = "r"),
                 c("C", "D", "E", "F"))

    eb <- expand_braces(c("Foo{A..F}", "Bar.{py,bash}", "{{Biz}}"), engine = "r")
    seb <- str_expand_braces(c("Foo{A..F}", "Bar.{py,bash}", "{{Biz}}"), engine = "r")
    expect_equal(length(eb), 9)
    expect_equal(length(seb), 3)
})

test_that("Bash 4.3 unit tests", {
    expect_equal(expand_braces_r("{1\\.2}"), c("{1.2}"))
    expect_equal(expand_braces_r("A{b,{d,e},{f,g}}Z"), c("AbZ", "AdZ", "AeZ", "AfZ", "AgZ"))
    ans <- c("PRE-aa-POST", "PRE-ab-POST", "PRE-aa-POST", "PRE-ab-POST",
             "PRE-ba-POST", "PRE-bb-POST", "PRE-ba-POST", "PRE-bb-POST")
    expect_equal(expand_braces_r("PRE-{a,b}{{a,b},a,b}-POST"), ans)
    expect_equal(expand_braces_r("a{,}"), c("a", "a"))
    expect_equal(expand_braces_r("{,}b"), c("b", "b"))
    expect_equal(expand_braces_r("a{,}b"), c("ab", "ab"))
    expect_equal(expand_braces_r("a{b}c"), c("a{b}c"))
    expect_equal(expand_braces_r("a{1..5}b"), c("a1b", "a2b", "a3b", "a4b", "a5b"))
    expect_equal(expand_braces_r("a{01..5}b"), c("a01b", "a02b", "a03b", "a04b", "a05b"))
    expect_equal(expand_braces_r("a{-01..5}b"), c("a-01b", "a000b", "a001b", "a002b", "a003b", "a004b", "a005b"))
    expect_equal(expand_braces_r("a{-01..5..3}b"), c("a-01b", "a002b", "a005b"))
    ans <- c("a001b", "a002b", "a003b", "a004b", "a005b", "a006b", "a007b",
             "a008b", "a009b")
    expect_equal(expand_braces_r("a{001..9}b"), ans)
    ans <- c("abxy", "abxz", "acdxy", "acdxz", "acexy", "acexz", "afhxy",
             "afhxz", "aghxy", "aghxz")
    expect_equal(expand_braces_r("a{b,c{d,e},{f,g}h}x{y,z}"), ans)
    ans <- c("a{b{cdfx}g}h", "a{b{cdfy}g}h", "a{b{cefx}g}h", "a{b{cefy}g}h")
    expect_equal(expand_braces_r("a{b{c{d,e}f{x,y}}g}h"), ans)
    expect_equal(expand_braces_r("a{b{c{d,e}f}g}h"), c("a{b{cdf}g}h", "a{b{cef}g}h"))
    expect_equal(expand_braces_r("a{{x,y},z}b"), c("axb", "ayb", "azb"))
    expect_equal(expand_braces_r("f{x,y{g,z}}h"), c("fxh", "fygh", "fyzh"))
    expect_equal(expand_braces_r("f{x,y{{g,z}}h}"), c("fx", "fy{g}h", "fy{z}h"))
    expect_equal(expand_braces_r("f{x,y{{g}h"), c("f{x,y{{g}h"))
    expect_equal(expand_braces_r("f{x,y{{g}}h"), c("f{x,y{{g}}h"))
    expect_equal(expand_braces_r("f{x,y{}g}h"), c("fxh", "fy{}gh"))
    expect_equal(expand_braces_r("z{a,b},c}d"), c("za,c}d", "zb,c}d"))
    expect_equal(expand_braces_r("{-01..5}"), c("-01", "000", "001", "002", "003", "004", "005"))
    ans <- c("-05", "000", "005", "010", "015", "020", "025", "030", "035",
             "040", "045", "050", "055", "060", "065", "070", "075", "080",
             "085", "090", "095", "100")
    expect_equal(expand_braces_r("{-05..100..5}"), ans)
    ans <- c("-05", "-04", "-03", "-02", "-01", "000", "001", "002", "003",
             "004", "005", "006", "007", "008", "009", "010", "011", "012",
             "013", "014", "015", "016", "017", "018", "019", "020", "021",
             "022", "023", "024", "025", "026", "027", "028", "029", "030",
             "031", "032", "033", "034", "035", "036", "037", "038", "039",
             "040", "041", "042", "043", "044", "045", "046", "047", "048",
             "049", "050", "051", "052", "053", "054", "055", "056", "057",
             "058", "059", "060", "061", "062", "063", "064", "065", "066",
             "067", "068", "069", "070", "071", "072", "073", "074", "075",
             "076", "077", "078", "079", "080", "081", "082", "083", "084",
             "085", "086", "087", "088", "089", "090", "091", "092", "093",
             "094", "095", "096", "097", "098", "099", "100")
    expect_equal(expand_braces_r("{-05..100}"), ans)
    expect_equal(expand_braces_r("{0..5..2}"), c("0", "2", "4"))
    expect_equal(expand_braces_r("{0001..05..2}"), c("0001", "0003", "0005"))
    expect_equal(expand_braces_r("{0001..-5..2}"), c("0001", "-001", "-003", "-005"))
    expect_equal(expand_braces_r("{0001..-5..-2}"), c("0001", "-001", "-003", "-005"))
    expect_equal(expand_braces_r("{0001..5..-2}"), c("0001", "0003", "0005"))
    expect_equal(expand_braces_r("{01..5}"), c("01", "02", "03", "04", "05"))
    expect_equal(expand_braces_r("{1..05}"), c("01", "02", "03", "04", "05"))
    expect_equal(expand_braces_r("{1..05..3}"), c("01", "04"))
    ans <- c("005", "006", "007", "008", "009", "010", "011", "012", "013",
             "014", "015", "016", "017", "018", "019", "020", "021", "022",
             "023", "024", "025", "026", "027", "028", "029", "030", "031",
             "032", "033", "034", "035", "036", "037", "038", "039", "040",
             "041", "042", "043", "044", "045", "046", "047", "048", "049",
             "050", "051", "052", "053", "054", "055", "056", "057", "058",
             "059", "060", "061", "062", "063", "064", "065", "066", "067",
             "068", "069", "070", "071", "072", "073", "074", "075", "076",
             "077", "078", "079", "080", "081", "082", "083", "084", "085",
             "086", "087", "088", "089", "090", "091", "092", "093", "094",
             "095", "096", "097", "098", "099", "100")
    expect_equal(expand_braces_r("{05..100}"), ans)
    expect_equal(expand_braces_r("{0a..0z}"), c("{0a..0z}"))
    expect_equal(expand_braces_r("{a,b}c,d}"), c("ac,d}", "bc,d}"))
    ans <- c("a", "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U", "T",
             "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H", "G", "F")
    expect_equal(expand_braces_r("{a..F}"), ans)
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
             "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\",
             "]", "^", "_", "`", "a", "b", "c", "d", "e", "f")
    expect_equal(expand_braces_r("{A..f}"), ans)
    expect_equal(expand_braces_r("{a..Z}"), c("a", "`", "_", "^", "]", "\\", "[", "Z"))
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
             "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\",
             "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
             "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
             "y", "z")
    expect_equal(expand_braces_r("{A..z}"), ans)
    ans <- c("z", "y", "x", "w", "v", "u", "t", "s", "r", "q", "p", "o", "n",
             "m", "l", "k", "j", "i", "h", "g", "f", "e", "d", "c", "b", "a",
             "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U", "T",
             "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H", "G",
             "F", "E", "D", "C", "B", "A")
    expect_equal(expand_braces_r("{z..A}"), ans)
    expect_equal(expand_braces_r("{Z..a}"), c("Z", "[", "\\", "]", "^", "_", "`", "a"))
    expect_equal(expand_braces_r("{a..F..2}"), c("a", "_", "]", "[", "Y", "W", "U", "S", "Q", "O", "M", "K", "I", "G"))
    ans <- c("A", "C", "E", "G", "I", "K", "M", "O", "Q", "S", "U", "W", "Y", "[", "]", "_", "a", "c", "e")
    expect_equal(expand_braces_r("{A..f..02}"), ans)
    expect_equal(expand_braces_r("{a..Z..5}"), c("a", "\\"))
    expect_equal(expand_braces_r("d{a..Z..5}b"), c("dab", "d\\b"))
    expect_equal(expand_braces_r("{A..z..10}"), c("A", "K", "U", "_", "i", "s"))
    ans <- c("z", "x", "v", "t", "r", "p", "n", "l", "j", "h", "f", "d", "b",
             "`", "^", "\\", "Z", "X", "V", "T", "R", "P", "N", "L", "J", "H",
             "F", "D", "B")
    expect_equal(expand_braces_r("{z..A..-2}"), ans)
    expect_equal(expand_braces_r("{Z..a..20}"), c("Z"))
    expect_equal(expand_braces_r("{a\\},b}"), c("a}", "b"))
    expect_equal(expand_braces_r("{x,y{,}g}"), c("x", "yg", "yg"))
    expect_equal(expand_braces_r("{x,y{}g}"), c("x", "y{}g"))
    expect_equal(expand_braces_r("{{a,b},c}"), c("a", "b", "c"))
    expect_equal(expand_braces_r("{{a,b}c}"), c("{ac}", "{bc}"))
    expect_equal(expand_braces_r("{{a,b},}"), c("a", "b", ""))
    expect_equal(expand_braces_r("X{{a,b},}X"), c("XaX", "XbX", "XX"))
    expect_equal(expand_braces_r("{{a,b},}c"), c("ac", "bc", "c"))
    expect_equal(expand_braces_r("{{a,b}.}"), c("{a.}", "{b.}"))
    expect_equal(expand_braces_r("{{a,b}}"), c("{a}", "{b}"))
    ans <- c("-10", "-09", "-08", "-07", "-06", "-05", "-04", "-03", "-02", "-01", "000")
    expect_equal(expand_braces_r("{-10..00}"), ans)
    expect_equal(expand_braces_r("{a,\\{a,b}c}"), c("ac}", "{ac}", "bc}"))
    expect_equal(expand_braces_r("a,\\{b,c}"), c("a,{b,c}"))
    expect_equal(expand_braces_r("{-10.\\.00}"), c("{-10..00}"))
    expect_equal(expand_braces_r("ff{c,b,a}"), c("ffc", "ffb", "ffa"))
    expect_equal(expand_braces_r("f{d,e,f}g"), c("fdg", "feg", "ffg"))
    expect_equal(expand_braces_r("{l,n,m}xyz"), c("lxyz", "nxyz", "mxyz"))
    expect_equal(expand_braces_r("{abc\\,def}"), c("{abc,def}"))
    expect_equal(expand_braces_r("{abc}"), c("{abc}"))
    expect_equal(expand_braces_r("{x\\,y,\\{abc\\},trie}"), c("x,y", "{abc}", "trie"))
    expect_equal(expand_braces_r("{}"), c("{}"))
    expect_equal(expand_braces_r("{ }"), c("{ }"))
    expect_equal(expand_braces_r("}"), c("}"))
    expect_equal(expand_braces_r("{"), c("{"))
    expect_equal(expand_braces_r("abcd{efgh"), c("abcd{efgh"))
    expect_equal(expand_braces_r("foo {1,2} bar"), c("foo 1 bar", "foo 2 bar"))
    expect_equal(expand_braces_r("{1..10}"), c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))
    expect_equal(expand_braces_r("{0..10,braces}"), c("0..10", "braces"))
    expect_equal(expand_braces_r("{{0..10},braces}"),
                 c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "braces"))
    ans <- c("x0y", "x1y", "x2y", "x3y", "x4y", "x5y", "x6y", "x7y", "x8y", "x9y", "x10y", "xbracesy")
    expect_equal(expand_braces_r("x{{0..10},braces}y"), ans)
    expect_equal(expand_braces_r("{3..3}"), c("3"))
    expect_equal(expand_braces_r("x{3..3}y"), c("x3y"))
    expect_equal(expand_braces_r("{10..1}"), c("10", "9", "8", "7", "6", "5", "4", "3", "2", "1"))
    expect_equal(expand_braces_r("{10..1}y"), c("10y", "9y", "8y", "7y", "6y", "5y", "4y", "3y", "2y", "1y"))
    expect_equal(expand_braces_r("x{10..1}y"), c("x10y", "x9y", "x8y", "x7y", "x6y", "x5y", "x4y", "x3y", "x2y", "x1y"))
    expect_equal(expand_braces_r("{a..f}"), c("a", "b", "c", "d", "e", "f"))
    expect_equal(expand_braces_r("{f..a}"), c("f", "e", "d", "c", "b", "a"))
    ans <- c("a", "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U",
             "T", "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H",
             "G", "F", "E", "D", "C", "B", "A")
    expect_equal(expand_braces_r("{a..A}"), ans)
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
             "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
             "[", "\\", "]", "^", "_", "`", "a")
    expect_equal(expand_braces_r("{A..a}"), ans)
    expect_equal(expand_braces_r("{f..f}"), c("f"))
    ans <- c("01 10", "01 11", "01 12", "01 13", "01 14", "01 15", "01 16",
             "01 17", "01 18", "01 19", "01 20", "02 10", "02 11", "02 12",
             "02 13", "02 14", "02 15", "02 16", "02 17", "02 18", "02 19",
             "02 20", "03 10", "03 11", "03 12", "03 13", "03 14", "03 15",
             "03 16", "03 17", "03 18", "03 19", "03 20", "04 10", "04 11",
             "04 12", "04 13", "04 14", "04 15", "04 16", "04 17", "04 18",
             "04 19", "04 20", "05 10", "05 11", "05 12", "05 13", "05 14",
             "05 15", "05 16", "05 17", "05 18", "05 19", "05 20", "06 10",
             "06 11", "06 12", "06 13", "06 14", "06 15", "06 16", "06 17",
             "06 18", "06 19", "06 20", "07 10", "07 11", "07 12", "07 13",
             "07 14", "07 15", "07 16", "07 17", "07 18", "07 19", "07 20",
             "08 10", "08 11", "08 12", "08 13", "08 14", "08 15", "08 16",
             "08 17", "08 18", "08 19", "08 20", "09 10", "09 11", "09 12",
             "09 13", "09 14", "09 15", "09 16", "09 17", "09 18", "09 19", "09 20")
    expect_equal(expand_braces_r("0{1..9} {10..20}"), ans)
    expect_equal(expand_braces_r("{-1..-10}"), c("-1", "-2", "-3", "-4", "-5", "-6", "-7", "-8", "-9", "-10"))
    ans <- c("-20", "-19", "-18", "-17", "-16", "-15", "-14", "-13", "-12", "-11",
             "-10", "-9", "-8", "-7", "-6", "-5", "-4", "-3", "-2", "-1", "0")
    expect_equal(expand_braces_r("{-20..0}"), ans)
    expect_equal(expand_braces_r("a-{b{d,e}}-c"), c("a-{bd}-c", "a-{be}-c"))
    expect_equal(expand_braces_r("{klklkl}{1,2,3}"), c("{klklkl}1", "{klklkl}2", "{klklkl}3"))
    expect_equal(expand_braces_r("{1..10..2}"), c("1", "3", "5", "7", "9"))
    expect_equal(expand_braces_r("{-1..-10..2}"), c("-1", "-3", "-5", "-7", "-9"))
    expect_equal(expand_braces_r("{-1..-10..-2}"), c("-1", "-3", "-5", "-7", "-9"))
    expect_equal(expand_braces_r("{10..1..-2}"), c("10", "8", "6", "4", "2"))
    expect_equal(expand_braces_r("{10..1..2}"), c("10", "8", "6", "4", "2"))
    expect_equal(expand_braces_r("{1..20..2}"), c("1", "3", "5", "7", "9", "11", "13", "15", "17", "19"))
    expect_equal(expand_braces_r("{1..20..20}"), c("1"))
    ans <- c("100", "95", "90", "85", "80", "75", "70", "65", "60", "55", "50",
             "45", "40", "35", "30", "25", "20", "15", "10", "5", "0")
    expect_equal(expand_braces_r("{100..0..5}"), ans)
    ans <- c("100", "95", "90", "85", "80", "75", "70", "65", "60", "55", "50",
             "45", "40", "35", "30", "25", "20", "15", "10", "5", "0")
    expect_equal(expand_braces_r("{100..0..-5}"), ans)
    ans <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
             "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
    expect_equal(expand_braces_r("{a..z}"), ans)
    expect_equal(expand_braces_r("{a..z..2}"), c("a", "c", "e", "g", "i", "k", "m", "o", "q", "s", "u", "w", "y"))
    expect_equal(expand_braces_r("{z..a..-2}"), c("z", "x", "v", "t", "r", "p", "n", "l", "j", "h", "f", "d", "b"))
    ans <- c("2147483645", "2147483646", "2147483647", "2147483648", "2147483649")
    expect_equal(expand_braces_r("{2147483645..2147483649}"), ans)
    expect_equal(expand_braces_r("{10..0..2}"), c("10", "8", "6", "4", "2", "0"))
    expect_equal(expand_braces_r("{10..0..-2}"), c("10", "8", "6", "4", "2", "0"))
    ans <- c("-50", "-45", "-40", "-35", "-30", "-25", "-20", "-15", "-10", "-5", "0")
    expect_equal(expand_braces_r("{-50..-0..5}"), ans)
    expect_equal(expand_braces_r("{1..10.f}"), c("{1..10.f}"))
    expect_equal(expand_braces_r("{1..ff}"), c("{1..ff}"))
    expect_equal(expand_braces_r("{1..10..ff}"), c("{1..10..ff}"))
    expect_equal(expand_braces_r("{1.20..2}"), c("{1.20..2}"))
    expect_equal(expand_braces_r("{1..20..f2}"), c("{1..20..f2}"))
    expect_equal(expand_braces_r("{1..20..2f}"), c("{1..20..2f}"))
    expect_equal(expand_braces_r("{1..2f..2}"), c("{1..2f..2}"))
    expect_equal(expand_braces_r("{1..ff..2}"), c("{1..ff..2}"))
    expect_equal(expand_braces_r("{1..ff}"), c("{1..ff}"))
    expect_equal(expand_braces_r("{1..0f}"), c("{1..0f}"))
    expect_equal(expand_braces_r("{1..10f}"), c("{1..10f}"))
    expect_equal(expand_braces_r("{1..10.f}"), c("{1..10.f}"))
    expect_equal(expand_braces_r("{},b}.h"), c("{},b}.h"))
    expect_equal(expand_braces_r("y{\\},a}x"), c("y}x", "yax"))
    expect_equal(expand_braces_r("{}a,b}c"), c("{}a,b}c"))
    expect_equal(expand_braces_r("{,}"), c("", ""))

    # Known 'incorrect behavior'
    expect_equal(expand_braces_r("X{a..#}X"), "X{a..#}X")

    skip("Not supported yet with 'r' engine")
    # Misc.
    expect_equal(expand_braces_r('"${var}"{x,y}'), c("${var}x", "${var}y")) # nolint
    ans <- c("XaX", "X`X", "X_X", "X^X", "X]X", "X\\X", "X[X", "XZX", "XYX", "XXX",
             "XWX", "XVX", "XUX", "XTX", "XSX", "XRX", "XQX", "XPX", "XOX",
             "XNX", "XMX", "XLX", "XKX", "XJX", "XIX", "XHX", "XGX", "XFX",
             "XEX", "XDX", "XCX", "XBX", "XAX", "X@X", "X?X", "X>X", "X=X",
             "X<X", "X;X", "X:X", "X9X", "X8X", "X7X", "X6X", "X5X", "X4X",
             "X3X", "X2X", "X1X", "X0X", "X/X", "X.X", "X-X", "X,X", "X+X",
             "X*X", "X)X", "X(X", "X'X", "X&X", "X%X", "X$X", "X#X")
    expect_equal(expand_braces_r("X{a..#}X"), ans)

    # Inner escaped terms
    expect_equal(expand_braces_r("{a,b\\}c,d}"), c("a", "b}c", "d"))
    expect_equal(expand_braces_r("{a,\\\\{a,b}c}"), c("a", "\\ac", "\\bc"))

    # Quoted terms
    expect_equal(expand_braces_r('{"x,x"}'), c("{x,x}"))
    expect_equal(expand_braces_r('{x","x}'), c("{x,x}"))
    expect_equal(expand_braces_r("\"{x,x}\""), c("{x,x}"))
    expect_equal(expand_braces_r("{x`,`x}"), c("{x,x}"))
    expect_equal(expand_braces_r("\"{a,b}{{a,b},a,b}\""), c("{a,b}{{a,b},a,b}"))
    expect_equal(expand_braces_r('{"klklkl"}{1,2,3}'), c("{klklkl}1", "{klklkl}2", "{klklkl}3"))
    expect_equal(expand_braces_r('{"x,x"}'), c("{x,x}"))

    expect_equal(expand_braces_r("a-{bdef-{g,i}-c"), c("a-{bdef-g-c", "a-{bdef-i-c"))
    expect_equal(expand_braces_r("{{a,b}"), c("{a", "{b"))
    expect_equal(expand_braces_r("{a{,b}"), c("{a", "{ab"))
    expect_equal(expand_braces_r("{a,b{c,d}"), c("{a,bc", "{a,bd"))
    expect_equal(expand_braces_r("\\{a,b}{{a,b},a,b}"), c("{a,b}a", "{a,b}b", "{a,b}a", "{a,b}b"))
    expect_equal(expand_braces_r("{{a,b}"), c("{a", "{b"))
    expect_equal(expand_braces_r("{a,b}}"), c("a}", "b}"))
    expect_equal(expand_braces_r("a{b,c{d,e},{f,g}h}x{y,z"),
                 c("abx{y,z", "acdx{y,z", "acex{y,z", "afhx{y,z", "aghx{y,z"))
    ans <- c("abx{y,z}", "acdx{y,z}", "acex{y,z}", "afhx{y,z}", "aghx{y,z}")
    expect_equal(expand_braces_r("a{b,c{d,e},{f,g}h}x{y,z\\}"), ans)
    expect_equal(expand_braces_r("a{b{c{d,e}f{x,y{{g}h"), c("a{b{cdf{x,y{{g}h", "a{b{cef{x,y{{g}h"))
    expect_equal(expand_braces_r("a{b{c{d,e}f{x,y{}g}h"), c("a{b{cdfxh", "a{b{cdfy{}gh", "a{b{cefxh", "a{b{cefy{}gh"))
    expect_equal(expand_braces_r("f{x,y{{g,z}}h"), c("f{x,y{g}h", "f{x,y{z}h"))
    expect_equal(expand_braces_r("z{a,b{,c}d"), c("z{a,bd", "z{a,bcd"))
})

test_that("Bash 4.3 unit tests with 'expand_braces_v8'", {
    skip_if_not_installed("V8")
    try_v8 <- try(expand_braces_v8("{a..d}"))
    skip_if(inherits(try_v8, "try-error"), "Seems like a faulty V8 installation")

    if (!isTRUE(getOption("bracer.engine.inform")))
        expect_message(expand_braces("{C..F}"), "Setting 'engine' argument to")

    expect_equal(expand_braces_v8("{1\\.2}"), c("{1.2}"))
    expect_equal(expand_braces_v8("A{b,{d,e},{f,g}}Z"), c("AbZ", "AdZ", "AeZ", "AfZ", "AgZ"))
    ans <- c("PRE-aa-POST", "PRE-ab-POST", "PRE-aa-POST", "PRE-ab-POST",
             "PRE-ba-POST", "PRE-bb-POST", "PRE-ba-POST", "PRE-bb-POST")
    expect_equal(expand_braces_v8("PRE-{a,b}{{a,b},a,b}-POST"), ans)
    expect_equal(expand_braces_v8("a{,}"), c("a", "a"))
    expect_equal(expand_braces_v8("{,}b"), c("b", "b"))
    expect_equal(expand_braces_v8("a{,}b"), c("ab", "ab"))
    expect_equal(expand_braces_v8("a{b}c"), c("a{b}c"))
    expect_equal(expand_braces_v8("a{1..5}b"), c("a1b", "a2b", "a3b", "a4b", "a5b"))
    expect_equal(expand_braces_v8("a{01..5}b"), c("a01b", "a02b", "a03b", "a04b", "a05b"))
    expect_equal(expand_braces_v8("a{-01..5}b"), c("a-01b", "a000b", "a001b", "a002b", "a003b", "a004b", "a005b"))
    expect_equal(expand_braces_v8("a{-01..5..3}b"), c("a-01b", "a002b", "a005b"))
    ans <- c("a001b", "a002b", "a003b", "a004b", "a005b", "a006b", "a007b",
             "a008b", "a009b")
    expect_equal(expand_braces_v8("a{001..9}b"), ans)
    ans <- c("abxy", "abxz", "acdxy", "acdxz", "acexy", "acexz", "afhxy",
             "afhxz", "aghxy", "aghxz")
    expect_equal(expand_braces_v8("a{b,c{d,e},{f,g}h}x{y,z}"), ans)
    ans <- c("a{b{cdfx}g}h", "a{b{cdfy}g}h", "a{b{cefx}g}h", "a{b{cefy}g}h")
    expect_equal(expand_braces_v8("a{b{c{d,e}f{x,y}}g}h"), ans)
    expect_equal(expand_braces_v8("a{b{c{d,e}f}g}h"), c("a{b{cdf}g}h", "a{b{cef}g}h"))
    expect_equal(expand_braces_v8("a{{x,y},z}b"), c("axb", "ayb", "azb"))
    expect_equal(expand_braces_v8("f{x,y{g,z}}h"), c("fxh", "fygh", "fyzh"))
    expect_equal(expand_braces_v8("f{x,y{{g,z}}h}"), c("fx", "fy{g}h", "fy{z}h"))
    expect_equal(expand_braces_v8("f{x,y{{g}h"), c("f{x,y{{g}h"))
    expect_equal(expand_braces_v8("f{x,y{{g}}h"), c("f{x,y{{g}}h"))
    expect_equal(expand_braces_v8("f{x,y{}g}h"), c("fxh", "fy{}gh"))
    expect_equal(expand_braces_v8("z{a,b},c}d"), c("za,c}d", "zb,c}d"))
    expect_equal(expand_braces_v8("{-01..5}"), c("-01", "000", "001", "002", "003", "004", "005"))
    ans <- c("-05", "000", "005", "010", "015", "020", "025", "030", "035",
             "040", "045", "050", "055", "060", "065", "070", "075", "080",
             "085", "090", "095", "100")
    expect_equal(expand_braces_v8("{-05..100..5}"), ans)
    ans <- c("-05", "-04", "-03", "-02", "-01", "000", "001", "002", "003",
             "004", "005", "006", "007", "008", "009", "010", "011", "012",
             "013", "014", "015", "016", "017", "018", "019", "020", "021",
             "022", "023", "024", "025", "026", "027", "028", "029", "030",
             "031", "032", "033", "034", "035", "036", "037", "038", "039",
             "040", "041", "042", "043", "044", "045", "046", "047", "048",
             "049", "050", "051", "052", "053", "054", "055", "056", "057",
             "058", "059", "060", "061", "062", "063", "064", "065", "066",
             "067", "068", "069", "070", "071", "072", "073", "074", "075",
             "076", "077", "078", "079", "080", "081", "082", "083", "084",
             "085", "086", "087", "088", "089", "090", "091", "092", "093",
             "094", "095", "096", "097", "098", "099", "100")
    expect_equal(expand_braces_v8("{-05..100}"), ans)
    expect_equal(expand_braces_v8("{0..5..2}"), c("0", "2", "4"))
    expect_equal(expand_braces_v8("{0001..05..2}"), c("0001", "0003", "0005"))
    expect_equal(expand_braces_v8("{0001..-5..2}"), c("0001", "-001", "-003", "-005"))
    expect_equal(expand_braces_v8("{0001..-5..-2}"), c("0001", "-001", "-003", "-005"))
    expect_equal(expand_braces_v8("{0001..5..-2}"), c("0001", "0003", "0005"))
    expect_equal(expand_braces_v8("{01..5}"), c("01", "02", "03", "04", "05"))
    expect_equal(expand_braces_v8("{1..05}"), c("01", "02", "03", "04", "05"))
    expect_equal(expand_braces_v8("{1..05..3}"), c("01", "04"))
    ans <- c("005", "006", "007", "008", "009", "010", "011", "012", "013",
             "014", "015", "016", "017", "018", "019", "020", "021", "022",
             "023", "024", "025", "026", "027", "028", "029", "030", "031",
             "032", "033", "034", "035", "036", "037", "038", "039", "040",
             "041", "042", "043", "044", "045", "046", "047", "048", "049",
             "050", "051", "052", "053", "054", "055", "056", "057", "058",
             "059", "060", "061", "062", "063", "064", "065", "066", "067",
             "068", "069", "070", "071", "072", "073", "074", "075", "076",
             "077", "078", "079", "080", "081", "082", "083", "084", "085",
             "086", "087", "088", "089", "090", "091", "092", "093", "094",
             "095", "096", "097", "098", "099", "100")
    expect_equal(expand_braces_v8("{05..100}"), ans)
    expect_equal(expand_braces_v8("{0a..0z}"), c("{0a..0z}"))
    expect_equal(expand_braces_v8("{a,b}c,d}"), c("ac,d}", "bc,d}"))
    ans <- c("a", "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U", "T",
             "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H", "G", "F")
    expect_equal(expand_braces_v8("{a..F}"), ans)
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
             "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\",
             "]", "^", "_", "`", "a", "b", "c", "d", "e", "f")
    expect_equal(expand_braces_v8("{A..f}"), ans)
    expect_equal(expand_braces_v8("{a..Z}"), c("a", "`", "_", "^", "]", "\\", "[", "Z"))
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
             "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\",
             "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
             "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
             "y", "z")
    expect_equal(expand_braces_v8("{A..z}"), ans)
    ans <- c("z", "y", "x", "w", "v", "u", "t", "s", "r", "q", "p", "o", "n",
             "m", "l", "k", "j", "i", "h", "g", "f", "e", "d", "c", "b", "a",
             "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U", "T",
             "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H", "G",
             "F", "E", "D", "C", "B", "A")
    expect_equal(expand_braces_v8("{z..A}"), ans)
    expect_equal(expand_braces_v8("{Z..a}"), c("Z", "[", "\\", "]", "^", "_", "`", "a"))
    expect_equal(expand_braces_v8("{a..F..2}"), c("a", "_", "]", "[", "Y", "W", "U", "S", "Q", "O", "M", "K", "I", "G"))
    ans <- c("A", "C", "E", "G", "I", "K", "M", "O", "Q", "S", "U", "W", "Y", "[", "]", "_", "a", "c", "e")
    expect_equal(expand_braces_v8("{A..f..02}"), ans)
    expect_equal(expand_braces_v8("{a..Z..5}"), c("a", "\\"))
    expect_equal(expand_braces_v8("d{a..Z..5}b"), c("dab", "d\\b"))
    expect_equal(expand_braces_v8("{A..z..10}"), c("A", "K", "U", "_", "i", "s"))
    ans <- c("z", "x", "v", "t", "r", "p", "n", "l", "j", "h", "f", "d", "b",
             "`", "^", "\\", "Z", "X", "V", "T", "R", "P", "N", "L", "J", "H",
             "F", "D", "B")
    expect_equal(expand_braces_v8("{z..A..-2}"), ans)
    expect_equal(expand_braces_v8("{Z..a..20}"), c("Z"))
    expect_equal(expand_braces_v8("{a\\},b}"), c("a}", "b"))
    expect_equal(expand_braces_v8("{x,y{,}g}"), c("x", "yg", "yg"))
    expect_equal(expand_braces_v8("{x,y{}g}"), c("x", "y{}g"))
    expect_equal(expand_braces_v8("{{a,b},c}"), c("a", "b", "c"))
    expect_equal(expand_braces_v8("{{a,b}c}"), c("{ac}", "{bc}"))
    expect_equal(expand_braces_v8("{{a,b},}"), c("a", "b", ""))
    expect_equal(expand_braces_v8("X{{a,b},}X"), c("XaX", "XbX", "XX"))
    expect_equal(expand_braces_v8("{{a,b},}c"), c("ac", "bc", "c"))
    expect_equal(expand_braces_v8("{{a,b}.}"), c("{a.}", "{b.}"))
    expect_equal(expand_braces_v8("{{a,b}}"), c("{a}", "{b}"))
    ans <- c("-10", "-09", "-08", "-07", "-06", "-05", "-04", "-03", "-02", "-01", "000")
    expect_equal(expand_braces_v8("{-10..00}"), ans)
    expect_equal(expand_braces_v8("{a,\\{a,b}c}"), c("ac}", "{ac}", "bc}"))
    expect_equal(expand_braces_v8("a,\\{b,c}"), c("a,{b,c}"))
    expect_equal(expand_braces_v8("{-10.\\.00}"), c("{-10..00}"))
    expect_equal(expand_braces_v8("ff{c,b,a}"), c("ffc", "ffb", "ffa"))
    expect_equal(expand_braces_v8("f{d,e,f}g"), c("fdg", "feg", "ffg"))
    expect_equal(expand_braces_v8("{l,n,m}xyz"), c("lxyz", "nxyz", "mxyz"))
    expect_equal(expand_braces_v8("{abc\\,def}"), c("{abc,def}"))
    expect_equal(expand_braces_v8("{abc}"), c("{abc}"))
    expect_equal(expand_braces_v8("{x\\,y,\\{abc\\},trie}"), c("x,y", "{abc}", "trie"))
    expect_equal(expand_braces_v8("{}"), c("{}"))
    expect_equal(expand_braces_v8("{ }"), c("{ }"))
    expect_equal(expand_braces_v8("}"), c("}"))
    expect_equal(expand_braces_v8("{"), c("{"))
    expect_equal(expand_braces_v8("abcd{efgh"), c("abcd{efgh"))
    expect_equal(expand_braces_v8("foo {1,2} bar"), c("foo 1 bar", "foo 2 bar"))
    expect_equal(expand_braces_v8("{1..10}"), c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))
    expect_equal(expand_braces_v8("{0..10,braces}"), c("0..10", "braces"))
    expect_equal(expand_braces_v8("{{0..10},braces}"),
                 c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "braces"))
    ans <- c("x0y", "x1y", "x2y", "x3y", "x4y", "x5y", "x6y", "x7y", "x8y", "x9y", "x10y", "xbracesy")
    expect_equal(expand_braces_v8("x{{0..10},braces}y"), ans)
    expect_equal(expand_braces_v8("{3..3}"), c("3"))
    expect_equal(expand_braces_v8("x{3..3}y"), c("x3y"))
    expect_equal(expand_braces_v8("{10..1}"),
                 c("10", "9", "8", "7", "6", "5", "4", "3", "2", "1"))
    expect_equal(expand_braces_v8("{10..1}y"),
                 c("10y", "9y", "8y", "7y", "6y", "5y", "4y", "3y", "2y", "1y"))
    expect_equal(expand_braces_v8("x{10..1}y"),
                 c("x10y", "x9y", "x8y", "x7y", "x6y", "x5y", "x4y", "x3y", "x2y", "x1y"))
    expect_equal(expand_braces_v8("{a..f}"), c("a", "b", "c", "d", "e", "f"))
    expect_equal(expand_braces_v8("{f..a}"), c("f", "e", "d", "c", "b", "a"))
    ans <- c("a", "`", "_", "^", "]", "\\", "[", "Z", "Y", "X", "W", "V", "U",
             "T", "S", "R", "Q", "P", "O", "N", "M", "L", "K", "J", "I", "H",
             "G", "F", "E", "D", "C", "B", "A")
    expect_equal(expand_braces_v8("{a..A}"), ans)
    ans <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
             "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
             "[", "\\", "]", "^", "_", "`", "a")
    expect_equal(expand_braces_v8("{A..a}"), ans)
    expect_equal(expand_braces_v8("{f..f}"), c("f"))
    ans <- c("01 10", "01 11", "01 12", "01 13", "01 14", "01 15", "01 16",
             "01 17", "01 18", "01 19", "01 20", "02 10", "02 11", "02 12",
             "02 13", "02 14", "02 15", "02 16", "02 17", "02 18", "02 19",
             "02 20", "03 10", "03 11", "03 12", "03 13", "03 14", "03 15",
             "03 16", "03 17", "03 18", "03 19", "03 20", "04 10", "04 11",
             "04 12", "04 13", "04 14", "04 15", "04 16", "04 17", "04 18",
             "04 19", "04 20", "05 10", "05 11", "05 12", "05 13", "05 14",
             "05 15", "05 16", "05 17", "05 18", "05 19", "05 20", "06 10",
             "06 11", "06 12", "06 13", "06 14", "06 15", "06 16", "06 17",
             "06 18", "06 19", "06 20", "07 10", "07 11", "07 12", "07 13",
             "07 14", "07 15", "07 16", "07 17", "07 18", "07 19", "07 20",
             "08 10", "08 11", "08 12", "08 13", "08 14", "08 15", "08 16",
             "08 17", "08 18", "08 19", "08 20", "09 10", "09 11", "09 12",
             "09 13", "09 14", "09 15", "09 16", "09 17", "09 18", "09 19", "09 20")
    expect_equal(expand_braces_v8("0{1..9} {10..20}"), ans)
    expect_equal(expand_braces_v8("{-1..-10}"), c("-1", "-2", "-3", "-4", "-5", "-6", "-7", "-8", "-9", "-10"))
    ans <- c("-20", "-19", "-18", "-17", "-16", "-15", "-14", "-13", "-12", "-11",
             "-10", "-9", "-8", "-7", "-6", "-5", "-4", "-3", "-2", "-1", "0")
    expect_equal(expand_braces_v8("{-20..0}"), ans)
    expect_equal(expand_braces_v8("a-{b{d,e}}-c"), c("a-{bd}-c", "a-{be}-c"))
    expect_equal(expand_braces_v8("{klklkl}{1,2,3}"), c("{klklkl}1", "{klklkl}2", "{klklkl}3"))
    expect_equal(expand_braces_v8("{1..10..2}"), c("1", "3", "5", "7", "9"))
    expect_equal(expand_braces_v8("{-1..-10..2}"), c("-1", "-3", "-5", "-7", "-9"))
    expect_equal(expand_braces_v8("{-1..-10..-2}"), c("-1", "-3", "-5", "-7", "-9"))
    expect_equal(expand_braces_v8("{10..1..-2}"), c("10", "8", "6", "4", "2"))
    expect_equal(expand_braces_v8("{10..1..2}"), c("10", "8", "6", "4", "2"))
    expect_equal(expand_braces_v8("{1..20..2}"), c("1", "3", "5", "7", "9", "11", "13", "15", "17", "19"))
    expect_equal(expand_braces_v8("{1..20..20}"), c("1"))
    ans <- c("100", "95", "90", "85", "80", "75", "70", "65", "60", "55", "50",
             "45", "40", "35", "30", "25", "20", "15", "10", "5", "0")
    expect_equal(expand_braces_v8("{100..0..5}"), ans)
    ans <- c("100", "95", "90", "85", "80", "75", "70", "65", "60", "55", "50",
             "45", "40", "35", "30", "25", "20", "15", "10", "5", "0")
    expect_equal(expand_braces_v8("{100..0..-5}"), ans)
    ans <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
             "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
    expect_equal(expand_braces_v8("{a..z}"), ans)
    expect_equal(expand_braces_v8("{a..z..2}"), c("a", "c", "e", "g", "i", "k", "m", "o", "q", "s", "u", "w", "y"))
    expect_equal(expand_braces_v8("{z..a..-2}"), c("z", "x", "v", "t", "r", "p", "n", "l", "j", "h", "f", "d", "b"))
    ans <- c("2147483645", "2147483646", "2147483647", "2147483648", "2147483649")
    expect_equal(expand_braces_v8("{2147483645..2147483649}"), ans)
    expect_equal(expand_braces_v8("{10..0..2}"), c("10", "8", "6", "4", "2", "0"))
    expect_equal(expand_braces_v8("{10..0..-2}"), c("10", "8", "6", "4", "2", "0"))
    ans <- c("-50", "-45", "-40", "-35", "-30", "-25", "-20", "-15", "-10", "-5", "0")
    expect_equal(expand_braces_v8("{-50..-0..5}"), ans)
    expect_equal(expand_braces_v8("{1..10.f}"), c("{1..10.f}"))
    expect_equal(expand_braces_v8("{1..ff}"), c("{1..ff}"))
    expect_equal(expand_braces_v8("{1..10..ff}"), c("{1..10..ff}"))
    expect_equal(expand_braces_v8("{1.20..2}"), c("{1.20..2}"))
    expect_equal(expand_braces_v8("{1..20..f2}"), c("{1..20..f2}"))
    expect_equal(expand_braces_v8("{1..20..2f}"), c("{1..20..2f}"))
    expect_equal(expand_braces_v8("{1..2f..2}"), c("{1..2f..2}"))
    expect_equal(expand_braces_v8("{1..ff..2}"), c("{1..ff..2}"))
    expect_equal(expand_braces_v8("{1..ff}"), c("{1..ff}"))
    expect_equal(expand_braces_v8("{1..0f}"), c("{1..0f}"))
    expect_equal(expand_braces_v8("{1..10f}"), c("{1..10f}"))
    expect_equal(expand_braces_v8("{1..10.f}"), c("{1..10.f}"))
    expect_equal(expand_braces_v8("{},b}.h"), c("{},b}.h"))
    expect_equal(expand_braces_v8("y{\\},a}x"), c("y}x", "yax"))
    expect_equal(expand_braces_v8("{}a,b}c"), c("{}a,b}c"))

    # Misc.
    expect_equal(expand_braces_v8('"${var}"{x,y}'), c("${var}x", "${var}y")) # nolint
    expect_equal(expand_braces_v8("{,}"), c("", ""))
    ans <- c("XaX", "X`X", "X_X", "X^X", "X]X", "X\\X", "X[X", "XZX", "XYX", "XXX",
             "XWX", "XVX", "XUX", "XTX", "XSX", "XRX", "XQX", "XPX", "XOX",
             "XNX", "XMX", "XLX", "XKX", "XJX", "XIX", "XHX", "XGX", "XFX",
             "XEX", "XDX", "XCX", "XBX", "XAX", "X@X", "X?X", "X>X", "X=X",
             "X<X", "X;X", "X:X", "X9X", "X8X", "X7X", "X6X", "X5X", "X4X",
             "X3X", "X2X", "X1X", "X0X", "X/X", "X.X", "X-X", "X,X", "X+X",
             "X*X", "X)X", "X(X", "X'X", "X&X", "X%X", "X$X", "X#X")
    expect_equal(expand_braces_v8("X{a..#}X"), ans)

    # Inner escaped terms
    expect_equal(expand_braces_v8("{a,b\\}c,d}"), c("a", "b}c", "d"))
    expect_equal(expand_braces_v8("{a,\\\\{a,b}c}"), c("a", "\\ac", "\\bc"))

    # Quoted terms
    expect_equal(expand_braces_v8('{"x,x"}'), c("{x,x}"))
    expect_equal(expand_braces_v8('{x","x}'), c("{x,x}"))
    expect_equal(expand_braces_v8("\"{x,x}\""), c("{x,x}"))
    expect_equal(expand_braces_v8("{x`,`x}"), c("{x,x}"))
    expect_equal(expand_braces_v8("\"{a,b}{{a,b},a,b}\""), c("{a,b}{{a,b},a,b}"))
    expect_equal(expand_braces_v8('{"klklkl"}{1,2,3}'),
                 c("{klklkl}1", "{klklkl}2", "{klklkl}3"))
    expect_equal(expand_braces_v8('{"x,x"}'), c("{x,x}"))

    expect_equal(expand_braces_v8("a-{bdef-{g,i}-c"), c("a-{bdef-g-c", "a-{bdef-i-c"))
    expect_equal(expand_braces_v8("{{a,b}"), c("{a", "{b"))
    expect_equal(expand_braces_v8("{a{,b}"), c("{a", "{ab"))
    expect_equal(expand_braces_v8("{a,b{c,d}"), c("{a,bc", "{a,bd"))
    expect_equal(expand_braces_v8("\\{a,b}{{a,b},a,b}"),
                 c("{a,b}a", "{a,b}b", "{a,b}a", "{a,b}b"))
    expect_equal(expand_braces_v8("{{a,b}"), c("{a", "{b"))
    expect_equal(expand_braces_v8("{a,b}}"), c("a}", "b}"))
    expect_equal(expand_braces_v8("a{b,c{d,e},{f,g}h}x{y,z"),
                 c("abx{y,z", "acdx{y,z", "acex{y,z", "afhx{y,z", "aghx{y,z"))
    ans <- c("abx{y,z}", "acdx{y,z}", "acex{y,z}", "afhx{y,z}", "aghx{y,z}")
    expect_equal(expand_braces_v8("a{b,c{d,e},{f,g}h}x{y,z\\}"), ans)
    expect_equal(expand_braces_v8("a{b{c{d,e}f{x,y{{g}h"),
                 c("a{b{cdf{x,y{{g}h", "a{b{cef{x,y{{g}h"))
    expect_equal(expand_braces_v8("a{b{c{d,e}f{x,y{}g}h"),
                 c("a{b{cdfxh", "a{b{cdfy{}gh", "a{b{cefxh", "a{b{cefy{}gh"))
    expect_equal(expand_braces_v8("f{x,y{{g,z}}h"), c("f{x,y{g}h", "f{x,y{z}h"))
    expect_equal(expand_braces_v8("z{a,b{,c}d"), c("z{a,bd", "z{a,bcd"))
})
