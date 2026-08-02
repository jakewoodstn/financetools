"""Curated US brand reference list for lowest-tier payee Suggest matching.

Used only after alias / fingerprint / prefix miss. Matching is strict:
contiguous fingerprint-token subsequence of a brand alias; longest wins.
"""

from __future__ import annotations

from dataclasses import dataclass

from app.services.payee_normalize import fingerprint_tokens

# Minimum alias length (chars) for subsequence matching. Shorter aliases
# (e.g. BP) only match when the bank fingerprint equals the alias exactly.
_MIN_ALIAS_CHARS = 3


@dataclass(frozen=True)
class _BrandPattern:
    tokens: tuple[str, ...]
    canonical: str
    char_len: int


def _entry(canonical: str, *aliases: str) -> tuple[str, tuple[str, ...]]:
    return canonical, (canonical, *aliases)


# ~100 retailers, ~100 restaurants, ~10 gas brands + common bank spellings.
_BRAND_ENTRIES: list[tuple[str, tuple[str, ...]]] = [
    # --- Gas ---
    _entry("Shell", "SHELL OIL", "SHELL SERVICE"),
    _entry("Exxon", "EXXONMOBIL", "EXXON MOBIL"),
    _entry("Mobil", "MOBIL OIL"),
    _entry("Chevron", "CHEVRON GAS"),
    _entry("BP", "BP GAS", "BP AMOCO"),
    _entry("Marathon", "MARATHON PETRO", "MARATHON PETROLEUM"),
    _entry("Speedway"),
    _entry("Circle K", "CIRCLEK"),
    _entry("Wawa"),
    _entry("QuikTrip", "QUIK TRIP", "QT"),
    _entry("Casey's", "CASEYS", "CASEY S GENERAL", "CASEYS GENERAL"),
    _entry("Buc-ee's", "BUCEES", "BUC EES"),
    _entry("Costco Gas", "COSTCO GAS", "COSTCO FUEL"),
    _entry("Sam's Club Fuel", "SAMS CLUB FUEL", "SAM S CLUB FUEL"),
    # --- Retailers ---
    _entry("Amazon", "AMZN", "AMAZON MKTPLACE", "AMAZON.COM", "AMZN MKTP", "AMAZON MARKETPLACE"),
    _entry("Walmart", "WAL MART", "WAL-MART", "WM SUPERCENTER", "WALMART.COM"),
    _entry("Target", "TARGET.COM"),
    _entry("Costco", "COSTCO WHSE", "COSTCO.COM"),
    _entry("Sam's Club", "SAMS CLUB", "SAM S CLUB"),
    _entry("Home Depot", "THE HOME DEPOT", "HOMEDEPOT"),
    _entry("Lowe's", "LOWES", "LOWE S"),
    _entry("Best Buy", "BESTBUY"),
    _entry("Apple", "APPLE.COM", "APPLE STORE", "APPLE.COM/BILL"),
    _entry("Microsoft", "MICROSOFT STORE", "MSFT"),
    _entry("Google", "GOOGLE STORE"),
    _entry("eBay", "EBAY", "EBAY INC"),
    _entry("Etsy"),
    _entry("Wayfair"),
    _entry("IKEA"),
    _entry("Macy's", "MACYS", "MACY S"),
    _entry("Nordstrom", "NORDSTROM RACK"),
    _entry("Kohl's", "KOHLS", "KOHL S"),
    _entry("JCPenney", "JCPENNEY", "JC PENNEY"),
    _entry("Ross", "ROSS STORES", "ROSS DRESS"),
    _entry("TJ Maxx", "TJMAXX", "T J MAXX"),
    _entry("Marshalls"),
    _entry("HomeGoods", "HOMEGOODS"),
    _entry("Burlington", "BURLINGTON STORES"),
    _entry("Old Navy", "OLDNAVY"),
    _entry("Gap", "GAP STORE", "THE GAP"),
    _entry("Banana Republic"),
    _entry("Athleta"),
    _entry("Nike", "NIKE.COM", "NIKE STORE"),
    _entry("Adidas", "ADIDAS.COM"),
    _entry("Under Armour", "UNDERARMOUR", "UNDER ARMOR"),
    _entry("Lululemon", "LULU LEMON"),
    _entry("Dick's Sporting Goods", "DICKS", "DICK S SPORTING"),
    _entry("Academy Sports"),
    _entry("REI"),
    _entry("Bass Pro Shops", "BASS PRO"),
    _entry("Cabela's", "CABELAS", "CABELA S"),
    _entry("Sephora"),
    _entry("Ulta", "ULTA BEAUTY"),
    _entry("Bath & Body Works", "BATH AND BODY", "BATH BODY WORKS"),
    _entry("Victoria's Secret", "VICTORIAS SECRET", "VICTORIA S SECRET"),
    _entry("CVS", "CVS PHARMACY"),
    _entry("Walgreens", "WALGREEN"),
    _entry("Rite Aid", "RITEAID"),
    _entry("Kroger"),
    _entry("Albertsons"),
    _entry("Safeway"),
    _entry("Publix"),
    _entry("H-E-B", "HEB", "H E B"),
    _entry("Meijer"),
    _entry("Aldi", "ALDI INC"),
    _entry("Trader Joe's", "TRADER JOE", "TRADER JOES"),
    _entry("Whole Foods", "WHOLEFOODS", "WHOLE FDS"),
    _entry("Sprouts", "SPROUTS FARMERS"),
    _entry("Food Lion", "FOODLION"),
    _entry("Giant Eagle"),
    _entry("Stop & Shop", "STOP AND SHOP", "STOP SHOP"),
    _entry("Wegmans"),
    _entry("Harris Teeter"),
    _entry("ShopRite", "SHOPRITE", "SHOP RITE"),
    _entry("WinCo", "WINCO FOODS"),
    _entry("Dollar General", "DOLLAR GEN"),
    _entry("Dollar Tree"),
    _entry("Family Dollar"),
    _entry("Five Below"),
    _entry("Office Depot", "OFFICEDEPOT"),
    _entry("Staples"),
    _entry("OfficeMax", "OFFICE MAX"),
    _entry("PetSmart", "PETSMART"),
    _entry("Petco"),
    _entry("Chewy", "CHEWY.COM"),
    _entry("AutoZone", "AUTOZONE"),
    _entry("O'Reilly Auto Parts", "OREILLY", "O REILLY AUTO"),
    _entry("Advance Auto Parts", "ADVANCE AUTO"),
    _entry("NAPA Auto Parts", "NAPA AUTO"),
    _entry("Harbor Freight"),
    _entry("Menards"),
    _entry("Ace Hardware"),
    _entry("Tractor Supply"),
    _entry("Bed Bath & Beyond", "BED BATH BEYOND"),
    _entry("Williams-Sonoma", "WILLIAMS SONOMA"),
    _entry("Pottery Barn"),
    _entry("Crate & Barrel", "CRATE AND BARREL", "CRATE BARREL"),
    _entry("West Elm"),
    _entry("Restoration Hardware", "RH.COM"),
    _entry("Overstock", "OVERSTOCK.COM"),
    _entry("Newegg"),
    _entry("B&H Photo", "B H PHOTO", "BH PHOTO"),
    _entry("Micro Center", "MICROCENTER"),
    _entry("GameStop", "GAMESTOP"),
    _entry("Barnes & Noble", "BARNES AND NOBLE", "BARNES NOBLE"),
    _entry("Books-A-Million", "BOOKS A MILLION"),
    _entry("Hobby Lobby"),
    _entry("Michaels"),
    _entry("Joann", "JOANN FABRICS", "JO ANN"),
    _entry("Party City"),
    _entry("Container Store", "THE CONTAINER STORE"),
    _entry("Ashley Furniture"),
    _entry("Rooms To Go"),
    _entry("Dillard's", "DILLARDS", "DILLARD S"),
    _entry("Neiman Marcus"),
    _entry("Saks Fifth Avenue", "SAKS FIFTH", "SAKS.COM"),
    _entry("Bloomingdale's", "BLOOMINGDALES", "BLOOMINGDALE S"),
    _entry("Anthropologie"),
    _entry("Free People"),
    _entry("Urban Outfitters"),
    _entry("Zara"),
    _entry("H&M", "H AND M", "HM.COM"),
    _entry("Uniqlo"),
    _entry("Forever 21", "FOREVER21"),
    _entry("American Eagle", "AEO"),
    _entry("Abercrombie", "ABERCROMBIE FITCH"),
    _entry("Hollister"),
    _entry("Express", "EXPRESS STORE"),
    _entry("J.Crew", "JCREW", "J CREW"),
    _entry("Madewell"),
    _entry("Patagonia"),
    _entry("The North Face", "NORTH FACE"),
    _entry("Columbia Sportswear", "COLUMBIA SPORTS"),
    _entry("Carhartt"),
    _entry("Timberland"),
    _entry("Vans"),
    _entry("Converse"),
    _entry("Foot Locker", "FOOTLOCKER"),
    _entry("Finish Line"),
    _entry("DSW", "DSW SHOE"),
    _entry("Famous Footwear"),
    _entry("Zappos"),
    _entry("Shoe Carnival"),
    _entry("LensCrafters", "LENSCRAFTERS"),
    _entry("Warby Parker"),
    _entry("Sunglass Hut"),
    _entry("GNC"),
    _entry("Vitamin Shoppe"),
    _entry("Build-A-Bear", "BUILD A BEAR"),
    _entry("LEGO Store", "LEGO STORE", "LEGO.COM"),
    _entry("Disney Store", "SHOPDISNEY"),
    # --- Restaurants ---
    _entry("McDonald's", "MCDONALDS", "MCDONALD", "MCD"),
    _entry("Starbucks", "SBUX"),
    _entry("Dunkin'", "DUNKIN", "DUNKIN DONUTS"),
    _entry("Subway"),
    _entry("Chipotle", "CHIPOTLE MEXICAN"),
    _entry("Taco Bell"),
    _entry("Wendy's", "WENDYS", "WENDY S"),
    _entry("Burger King", "BURGERKING"),
    _entry("Chick-fil-A", "CHICK FIL A", "CHICKFILA", "CFA"),
    _entry("Popeyes", "POPEYES LOUISIANA"),
    _entry("KFC", "KENTUCKY FRIED"),
    _entry("Pizza Hut"),
    _entry("Domino's", "DOMINOS", "DOMINO S"),
    _entry("Papa John's", "PAPA JOHNS", "PAPA JOHN S"),
    _entry("Little Caesars", "LITTLE CAESAR"),
    _entry("Panera Bread", "PANERA"),
    _entry("Olive Garden"),
    _entry("Applebee's", "APPLEBEES", "APPLEBEE S"),
    _entry("Chili's", "CHILIS", "CHILI S"),
    _entry("Outback Steakhouse", "OUTBACK", "OUTBACK STEAK"),
    _entry("Red Lobster"),
    _entry("Texas Roadhouse"),
    _entry("Buffalo Wild Wings", "BUFFALO WILD", "BWW", "BDUBS"),
    _entry("Wingstop"),
    _entry("Sonic", "SONIC DRIVE"),
    _entry("Arby's", "ARBYS", "ARBY S"),
    _entry("Jack in the Box"),
    _entry("Carl's Jr", "CARLS JR", "CARL S JR"),
    _entry("Hardee's", "HARDEES", "HARDEE S"),
    _entry("Whataburger"),
    _entry("In-N-Out", "IN N OUT"),
    _entry("Five Guys"),
    _entry("Shake Shack"),
    _entry("Culver's", "CULVERS", "CULVER S"),
    _entry("Raising Cane's", "RAISING CANES", "RAISING CANE"),
    _entry("Zaxby's", "ZAXBYS", "ZAXBY S"),
    _entry("Bojangles"),
    _entry("Church's Chicken", "CHURCHS CHICKEN", "CHURCH S CHICKEN"),
    _entry("Panda Express"),
    _entry("Pei Wei"),
    _entry("PF Chang's", "PF CHANGS", "P F CHANG"),
    _entry("Cheesecake Factory"),
    _entry("Red Robin"),
    _entry("TGI Friday's", "TGI FRIDAYS", "TGIF"),
    _entry("IHOP"),
    _entry("Denny's", "DENNYS", "DENNY S"),
    _entry("Waffle House"),
    _entry("Cracker Barrel"),
    _entry("Bob Evans"),
    _entry("Golden Corral"),
    _entry("Hooters"),
    _entry("LongHorn Steakhouse", "LONGHORN STEAK"),
    _entry("Bonefish Grill"),
    _entry("Carrabba's", "CARRABBAS", "CARRABBA S"),
    _entry("Fleming's", "FLEMINGS"),
    _entry("Ruth's Chris", "RUTHS CHRIS", "RUTH S CHRIS"),
    _entry("Capital Grille", "THE CAPITAL GRILLE"),
    _entry("Yard House"),
    _entry("BJ's Restaurant", "BJS RESTAURANT", "BJ S RESTAURANT"),
    _entry("California Pizza Kitchen", "CPK"),
    _entry("Noodles & Company", "NOODLES COMPANY", "NOODLES AND COMPANY"),
    _entry("Qdoba"),
    _entry("Moe's Southwest Grill", "MOES", "MOE S SOUTHWEST"),
    _entry("Firehouse Subs"),
    _entry("Jersey Mike's", "JERSEY MIKES", "JERSEY MIKE"),
    _entry("Jimmy John's", "JIMMY JOHNS", "JIMMY JOHN"),
    _entry("Potbelly", "POTBELLY SANDWICH"),
    _entry("Which Wich"),
    _entry("Tropical Smoothie"),
    _entry("Smoothie King"),
    _entry("Jamba Juice", "JAMBA"),
    _entry("Orange Julius"),
    _entry("Auntie Anne's", "AUNTIE ANNES", "AUNTIE ANNE"),
    _entry("Cinnabon"),
    _entry("Krispy Kreme"),
    _entry("Tim Hortons"),
    _entry("Peet's Coffee", "PEETS", "PEET S COFFEE"),
    _entry("Dutch Bros"),
    _entry("Caribou Coffee"),
    _entry("The Coffee Bean", "COFFEE BEAN"),
    _entry("Einstein Bros", "EINSTEIN BROTHERS"),
    _entry("Bruegger's", "BRUEGGERS"),
    _entry("Corner Bakery"),
    _entry("Au Bon Pain"),
    _entry("Sweetgreen"),
    _entry("Cava"),
    _entry("Blaze Pizza"),
    _entry("MOD Pizza"),
    _entry("Pizza Ranch"),
    _entry("Round Table Pizza", "ROUND TABLE"),
    _entry("Marco's Pizza", "MARCOS PIZZA", "MARCO S PIZZA"),
    _entry("Hungry Howie's", "HUNGRY HOWIES", "HUNGRY HOWIE"),
    _entry("White Castle"),
    _entry("Steak 'n Shake", "STEAK N SHAKE", "STEAK AND SHAKE"),
    _entry("Checkers", "RALLY'S", "RALLYS"),
    _entry("Del Taco"),
    _entry("El Pollo Loco"),
    _entry("Pollo Tropical"),
    _entry("Boston Market"),
    _entry("Nando's", "NANDOS", "NANDO S"),
    _entry("Papa Murphy's", "PAPA MURPHYS", "PAPA MURPHY"),
    _entry("Sbarro"),
    _entry("Fazoli's", "FAZOLIS", "FAZOLI S"),
    _entry("Maggiano's", "MAGGIANOS", "MAGGIANO"),
    _entry("Bahama Breeze"),
    _entry("Seasons 52"),
    _entry("Eddie V's", "EDDIE VS"),
]


def _tokens_for_phrase(phrase: str) -> tuple[str, ...]:
    return tuple(fingerprint_tokens(phrase))


def _build_index(entries: list[tuple[str, tuple[str, ...]]]) -> list[_BrandPattern]:
    seen: set[tuple[str, ...]] = set()
    patterns: list[_BrandPattern] = []
    for canonical, phrases in entries:
        for phrase in phrases:
            tokens = _tokens_for_phrase(phrase)
            if not tokens:
                continue
            if tokens in seen:
                continue
            seen.add(tokens)
            patterns.append(
                _BrandPattern(
                    tokens=tokens,
                    canonical=canonical,
                    char_len=sum(len(t) for t in tokens),
                )
            )
    patterns.sort(key=lambda p: (len(p.tokens), p.char_len), reverse=True)
    return patterns


_BRAND_INDEX: list[_BrandPattern] = _build_index(_BRAND_ENTRIES)


def _is_contiguous_subsequence(haystack: list[str], needle: tuple[str, ...]) -> bool:
    if not needle:
        return False
    n = len(needle)
    if n > len(haystack):
        return False
    for i in range(len(haystack) - n + 1):
        if tuple(haystack[i : i + n]) == needle:
            return True
    return False


def match_brand(raw: str | None) -> str | None:
    """Return canonical brand name if bank text matches a reference alias."""
    tokens = fingerprint_tokens(raw)
    if not tokens:
        return None

    for pattern in _BRAND_INDEX:
        if pattern.char_len < _MIN_ALIAS_CHARS:
            if tuple(tokens) == pattern.tokens:
                return pattern.canonical
            continue
        # Single-token aliases must be the first significant token so we don't
        # mis-hit e.g. AMERICAN EXPRESS → clothing "Express".
        if len(pattern.tokens) == 1:
            if tokens[0] == pattern.tokens[0]:
                return pattern.canonical
            continue
        if _is_contiguous_subsequence(tokens, pattern.tokens):
            return pattern.canonical
    return None
