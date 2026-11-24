from math import cos, pi, sin

from fontTools.fontBuilder import FontBuilder
from fontTools.misc.timeTools import timestampSinceEpoch
from fontTools.pens.ttGlyphPen import TTGlyphPen


def polygon(pen, points):
    pen.moveTo(points[0])
    for point in points[1:]:
        pen.lineTo(point)
    pen.closePath()


def ring(pen, radius, thickness):
    for size, direction in [(radius, -1), (radius - thickness, 1)]:
        points = [
            (round(500 + size * cos(angle)), round(350 + size * sin(angle)))
            for step in range(36)
            for angle in [direction * step * pi / 18]
        ]
        polygon(pen, points)


def glyph(contours):
    pen = TTGlyphPen(None)
    for contour in contours:
        polygon(pen, contour)
    return pen.glyph()


symbols = {
    0x2197: ('upRight', 720, [[(160, 143), (505, 488), (505, 308), (570, 308),
                               (570, 600), (278, 600), (278, 535), (458, 535), (113, 190)]]),
    0x2301: ('wave', 1000, [[(105, 322), (311, 455), (490, 342), (673, 431),
                            (922, 257), (880, 198), (667, 349), (485, 260), (312, 366), (144, 260)]]),
    0x2630: ('menu', 850, [[(115, y), (115, y + 62), (735, y + 62), (735, y)]
                           for y in (146, 319, 492)]),
    0x2934: ('turnUp', 1000, [[(114, 210), (320, 210), (451, 240), (543, 315), (577, 410),
                              (577, 520), (443, 386), (392, 436), (612, 656), (832, 436),
                              (781, 386), (647, 520), (647, 398), (603, 273), (483, 176),
                              (328, 140), (114, 140)]]),
}

glyphs = {'.notdef': glyph([])}
metrics = {'.notdef': (500, 0)}
characters = {}
for code, (name, width, contours) in symbols.items():
    characters[code] = name
    glyphs[name] = glyph(contours)
    metrics[name] = (width, min(x for contour in contours for x, _ in contour))

pen = TTGlyphPen(None)
ring(pen, 345, 60)
ring(pen, 205, 60)
characters[0x25CE] = 'bullseye'
glyphs['bullseye'] = pen.glyph()
metrics['bullseye'] = (1000, 155)

font = FontBuilder(1000, isTTF=True)
font.setupGlyphOrder(list(glyphs))
font.setupCharacterMap(characters)
font.setupGlyf(glyphs)
font.setupHorizontalMetrics(metrics)
font.setupHorizontalHeader(ascent=800, descent=-200)
font.setupNameTable({
    'familyName': 'Genvira Symbols',
    'styleName': 'Regular',
    'uniqueFontIdentifier': 'Genvira Symbols Regular',
    'fullName': 'Genvira Symbols Regular',
    'psName': 'GenviraSymbols-Regular',
    'version': 'Version 1.0',
})
font.setupOS2(sTypoAscender=800, sTypoDescender=-200, usWinAscent=800, usWinDescent=200)
font.setupPost()
font.font.flavor = 'woff'
font.font['head'].created = font.font['head'].modified = timestampSinceEpoch(0)
font.font.recalcTimestamp = False
font.save('wp-content/themes/genvira/assets/genvira-symbols.woff')
