from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Date, DateTime, ForeignKey, Integer, Numeric, SmallInteger, String, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class Account(Base):
    __tablename__ = "accounts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    account_name: Mapped[str | None] = mapped_column(String(50))
    created_at: Mapped[date | None] = mapped_column(Date)
    closed_on: Mapped[date | None] = mapped_column(Date)
    import_transactions: Mapped[int | None] = mapped_column(SmallInteger)

    bank_transactions: Mapped[list["BankTransaction"]] = relationship(back_populates="account")
    transaction_accounts: Mapped[list["TransactionAccount"]] = relationship(back_populates="account")
    raw_transactions: Mapped[list["RawTransaction"]] = relationship(back_populates="account")
    balance_observations: Mapped[list["BalanceObservation"]] = relationship(back_populates="account")
    daily_balances: Mapped[list["DailyBalance"]] = relationship(back_populates="account")


class TransactionAccount(Base):
    __tablename__ = "transaction_accounts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(255), unique=True)
    account_id: Mapped[int | None] = mapped_column(ForeignKey("accounts.id"))

    account: Mapped[Account | None] = relationship(back_populates="transaction_accounts")


class SpendingCategoryGroup(Base):
    __tablename__ = "spending_category_groups"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    group_name: Mapped[str | None] = mapped_column(String(200))

    categories: Mapped[list["SpendingCategory"]] = relationship(back_populates="group")


class SpendingCategory(Base):
    __tablename__ = "spending_categories"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    category_name: Mapped[str | None] = mapped_column(String(200))
    spending_category_group_id: Mapped[int] = mapped_column(ForeignKey("spending_category_groups.id"), default=0)

    group: Mapped[SpendingCategoryGroup] = relationship(back_populates="categories")
    transactions: Mapped[list["BankTransaction"]] = relationship(back_populates="spending_category")
    splits: Mapped[list["CategorySplitDetail"]] = relationship(back_populates="spending_category")
    category_rules: Mapped[list["CategoryRule"]] = relationship(back_populates="spending_category")
    category_suggestions: Mapped[list["CategorySuggestion"]] = relationship(back_populates="spending_category")


class Payee(Base):
    __tablename__ = "payees"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    canonical_name: Mapped[str] = mapped_column(String(500))
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    aliases: Mapped[list["PayeeAlias"]] = relationship(back_populates="payee")
    category_rules: Mapped[list["CategoryRule"]] = relationship(back_populates="payee")
    transactions: Mapped[list["BankTransaction"]] = relationship(back_populates="payee")


class PayeeAlias(Base):
    __tablename__ = "payee_aliases"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    payee_id: Mapped[int] = mapped_column(ForeignKey("payees.id"))
    raw_text: Mapped[str] = mapped_column(String(1000))
    source: Mapped[str] = mapped_column(String(50))

    payee: Mapped[Payee] = relationship(back_populates="aliases")


class CategoryRule(Base):
    __tablename__ = "category_rules"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    payee_id: Mapped[int] = mapped_column(ForeignKey("payees.id"))
    spending_category_id: Mapped[int] = mapped_column(ForeignKey("spending_categories.id"))
    source: Mapped[str] = mapped_column(String(50))
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    payee: Mapped[Payee] = relationship(back_populates="category_rules")
    spending_category: Mapped[SpendingCategory] = relationship(back_populates="category_rules")


class CategorySuggestion(Base):
    __tablename__ = "category_suggestions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    bank_transaction_id: Mapped[int] = mapped_column(ForeignKey("bank_transactions.id"))
    spending_category_id: Mapped[int] = mapped_column(ForeignKey("spending_categories.id"))
    confidence: Mapped[Decimal | None] = mapped_column(Numeric(5, 4))
    source: Mapped[str] = mapped_column(String(50))
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    bank_transaction: Mapped["BankTransaction"] = relationship(back_populates="category_suggestions")
    spending_category: Mapped[SpendingCategory] = relationship(back_populates="category_suggestions")


class BankTransaction(Base):
    __tablename__ = "bank_transactions"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    external_id: Mapped[int] = mapped_column(BigInteger, unique=True)
    transaction_date: Mapped[date | None] = mapped_column(Date)
    loaded_date: Mapped[datetime | None] = mapped_column(DateTime)
    description: Mapped[str | None] = mapped_column(String(1000))
    import_category: Mapped[str | None] = mapped_column(String(100))
    amount: Mapped[Decimal | None] = mapped_column(Numeric(19, 4))
    spending_category_id: Mapped[int | None] = mapped_column(ForeignKey("spending_categories.id"))
    orig_description: Mapped[str | None] = mapped_column(String(1000))
    category_status: Mapped[int] = mapped_column(Integer, default=0)
    bank_orig_description: Mapped[str | None] = mapped_column(String(1000))
    account_id: Mapped[int] = mapped_column(ForeignKey("accounts.id"))
    accounting_date: Mapped[date | None] = mapped_column(Date)
    payee_id: Mapped[int | None] = mapped_column(ForeignKey("payees.id"))
    source_external_id: Mapped[str | None] = mapped_column(String(200))
    last_import_batch_id: Mapped[int | None] = mapped_column(ForeignKey("import_batches.id"))

    account: Mapped[Account] = relationship(back_populates="bank_transactions")
    spending_category: Mapped[SpendingCategory | None] = relationship(back_populates="transactions")
    payee: Mapped[Payee | None] = relationship(back_populates="transactions")
    splits: Mapped[list["CategorySplitDetail"]] = relationship(back_populates="bank_transaction")
    tagged_events: Mapped[list["TransactionTaggedEvent"]] = relationship(back_populates="bank_transaction")
    category_suggestions: Mapped[list["CategorySuggestion"]] = relationship(back_populates="bank_transaction")
    outbound_transfer: Mapped["TransferLink | None"] = relationship(
        back_populates="outbound_transaction",
        foreign_keys="TransferLink.outbound_bank_transaction_id",
        uselist=False,
    )
    inbound_transfer: Mapped["TransferLink | None"] = relationship(
        back_populates="inbound_transaction",
        foreign_keys="TransferLink.inbound_bank_transaction_id",
        uselist=False,
    )
    promoted_from: Mapped["RawTransaction | None"] = relationship(
        back_populates="bank_transaction",
        uselist=False,
    )


class CategorySplitDetail(Base):
    __tablename__ = "category_split_details"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    external_id: Mapped[int] = mapped_column(BigInteger, unique=True)
    bank_transaction_id: Mapped[int] = mapped_column(ForeignKey("bank_transactions.id"))
    spending_category_id: Mapped[int | None] = mapped_column(ForeignKey("spending_categories.id"))
    split_amount: Mapped[Decimal | None] = mapped_column(Numeric(19, 4))

    bank_transaction: Mapped[BankTransaction] = relationship(back_populates="splits")
    spending_category: Mapped[SpendingCategory | None] = relationship(back_populates="splits")
    tagged_events: Mapped[list["TransactionTaggedEvent"]] = relationship(back_populates="category_split_detail")


class TaggedEvent(Base):
    __tablename__ = "tagged_events"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    tag: Mapped[str] = mapped_column(String(200))
    description: Mapped[str | None] = mapped_column(String(1000))
    effective_date: Mapped[date | None] = mapped_column(Date)
    retired_date: Mapped[date | None] = mapped_column(Date)

    transaction_links: Mapped[list["TransactionTaggedEvent"]] = relationship(back_populates="tagged_event")


class TransactionTaggedEvent(Base):
    __tablename__ = "transaction_tagged_events"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    bank_transaction_id: Mapped[int] = mapped_column(ForeignKey("bank_transactions.id"))
    tagged_event_id: Mapped[int] = mapped_column(ForeignKey("tagged_events.id"))
    category_split_detail_id: Mapped[int | None] = mapped_column(ForeignKey("category_split_details.id"))
    tagged_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    bank_transaction: Mapped[BankTransaction] = relationship(back_populates="tagged_events")
    tagged_event: Mapped[TaggedEvent] = relationship(back_populates="transaction_links")
    category_split_detail: Mapped[CategorySplitDetail | None] = relationship(back_populates="tagged_events")


class ImportBatch(Base):
    __tablename__ = "import_batches"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    source: Mapped[str] = mapped_column(String(50))
    filename: Mapped[str | None] = mapped_column(String(500))
    imported_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")
    status: Mapped[str] = mapped_column(String(50))
    account_id: Mapped[int | None] = mapped_column(ForeignKey("accounts.id"))

    raw_transactions: Mapped[list["RawTransaction"]] = relationship(back_populates="import_batch")


class RawTransaction(Base):
    __tablename__ = "raw_transactions"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    import_batch_id: Mapped[int] = mapped_column(ForeignKey("import_batches.id"))
    account_id: Mapped[int] = mapped_column(ForeignKey("accounts.id"))
    transaction_date: Mapped[date | None] = mapped_column(Date)
    amount: Mapped[Decimal | None] = mapped_column(Numeric(19, 4))
    bank_orig_description: Mapped[str | None] = mapped_column(String(1000))
    import_category: Mapped[str | None] = mapped_column(String(100))
    dedupe_hash: Mapped[str] = mapped_column(String(64), unique=True)
    source_external_id: Mapped[str | None] = mapped_column(String(200))
    bank_transaction_id: Mapped[int | None] = mapped_column(ForeignKey("bank_transactions.id"))
    promotion_status: Mapped[str | None] = mapped_column(String(50))
    promotion_note: Mapped[str | None] = mapped_column(Text)

    import_batch: Mapped[ImportBatch] = relationship(back_populates="raw_transactions")
    account: Mapped[Account] = relationship(back_populates="raw_transactions")
    bank_transaction: Mapped[BankTransaction | None] = relationship(back_populates="promoted_from")


class TransferLink(Base):
    __tablename__ = "transfer_links"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    outbound_bank_transaction_id: Mapped[int] = mapped_column(ForeignKey("bank_transactions.id"), unique=True)
    inbound_bank_transaction_id: Mapped[int] = mapped_column(ForeignKey("bank_transactions.id"), unique=True)
    linked_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    outbound_transaction: Mapped[BankTransaction] = relationship(
        back_populates="outbound_transfer",
        foreign_keys=[outbound_bank_transaction_id],
    )
    inbound_transaction: Mapped[BankTransaction] = relationship(
        back_populates="inbound_transfer",
        foreign_keys=[inbound_bank_transaction_id],
    )


class BalanceObservation(Base):
    __tablename__ = "balance_observations"
    __table_args__ = (
        UniqueConstraint(
            "account_id",
            "as_of_date",
            name="uq_balance_observations_account_date",
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    account_id: Mapped[int] = mapped_column(ForeignKey("accounts.id"))
    as_of_date: Mapped[date] = mapped_column(Date)
    amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))
    observed_at: Mapped[datetime] = mapped_column(DateTime, server_default="now()")

    account: Mapped[Account] = relationship(back_populates="balance_observations")


class DailyBalance(Base):
    __tablename__ = "daily_balances"

    account_id: Mapped[int] = mapped_column(ForeignKey("accounts.id"), primary_key=True)
    measurement_date: Mapped[date] = mapped_column(Date, primary_key=True)
    amount: Mapped[Decimal] = mapped_column(Numeric(19, 4))

    account: Mapped[Account] = relationship(back_populates="daily_balances")
