from app.services.lookup_bookmarks import (
    DEFAULT_BOOKMARKS,
    LookupBookmark,
    fill_bookmark_url,
    url_needs_transaction,
    _merge_stock_bookmarks,
    _parse_bookmarks,
)


def test_default_bookmarks_parse_when_empty():
    bookmarks = _parse_bookmarks(None)
    assert len(bookmarks) == len(DEFAULT_BOOKMARKS)
    assert bookmarks[0].label == "Amazon orders"
    assert any(b.id == "venmo-activity" for b in bookmarks)


def test_fill_bookmark_url_encodes_tokens():
    url = fill_bookmark_url(
        "https://www.google.com/search?q={payee}+{abs_amount}",
        {"payee": "Adhere Health", "abs_amount": "12.50"},
    )
    assert "Adhere+Health" in url or "Adhere%20Health" in url
    assert "12.50" in url


def test_fill_leaves_unknown_token():
    assert "{unknown}" in fill_bookmark_url("https://example.com/{unknown}", {})


def test_url_needs_transaction():
    assert not url_needs_transaction("https://www.amazon.com/gp/your-account/order-history")
    assert not url_needs_transaction("https://account.venmo.com/account/statement")
    assert url_needs_transaction("https://www.google.com/search?q={payee}+{abs_amount}")


def test_merge_adds_venmo_to_older_saved_list():
    older = [
        LookupBookmark(id="amazon-orders", label="Amazon orders", url="https://www.amazon.com/x"),
        LookupBookmark(id="paypal-activity", label="PayPal activity", url="https://www.paypal.com/x"),
        LookupBookmark(
            id="google-search",
            label="Google payee + amount",
            url="https://www.google.com/search?q={payee}+{abs_amount}",
        ),
    ]
    merged = _merge_stock_bookmarks(older)
    assert [b.id for b in merged] == [
        "amazon-orders",
        "paypal-activity",
        "venmo-activity",
        "google-search",
    ]
