from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Date, DateTime, ForeignKey, Integer, Numeric, SmallInteger, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base


class Account(Base):
    __tablename__ = "account"

    account_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    account_name: Mapped[str | None] = mapped_column(String(50))
    created_at: Mapped[date | None] = mapped_column(Date)
    closed_on: Mapped[date | None] = mapped_column(Date)
    import_transactions: Mapped[int | None] = mapped_column(SmallInteger)

    bank_transactions: Mapped[list["BankTransaction"]] = relationship(back_populates="account")


class TransactionAccount(Base):
    __tablename__ = "transaction_account"

    transaction_account_name: Mapped[str] = mapped_column(String(255), primary_key=True)
    account_id: Mapped[int | None] = mapped_column(ForeignKey("account.account_id"))

    account: Mapped[Account | None] = relationship()


class SpendingCategoryGroup(Base):
    __tablename__ = "spending_category_group"

    group_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    group_name: Mapped[str | None] = mapped_column(String(200))

    categories: Mapped[list["SpendingCategory"]] = relationship(back_populates="group")


class SpendingCategory(Base):
    __tablename__ = "spending_category"

    category_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    category_name: Mapped[str | None] = mapped_column(String(200))
    group_id: Mapped[int] = mapped_column(ForeignKey("spending_category_group.group_id"), default=0)

    group: Mapped[SpendingCategoryGroup] = relationship(back_populates="categories")
    transactions: Mapped[list["BankTransaction"]] = relationship(back_populates="category")
    splits: Mapped[list["CategorySplitDetail"]] = relationship(back_populates="spending_category")


class BankTransaction(Base):
    __tablename__ = "bank_transaction"

    transaction_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=False)
    transaction_date: Mapped[date | None] = mapped_column(Date)
    loaded_date: Mapped[datetime | None] = mapped_column(DateTime)
    description: Mapped[str | None] = mapped_column(String(1000))
    import_category: Mapped[str | None] = mapped_column("category", String(100))
    amount: Mapped[Decimal | None] = mapped_column(Numeric(19, 4))
    account: Mapped[str | None] = mapped_column(String(100))
    category_id: Mapped[int | None] = mapped_column(ForeignKey("spending_category.category_id"))
    orig_description: Mapped[str | None] = mapped_column(String(1000))
    category_status: Mapped[int] = mapped_column(Integer, default=0)
    bank_orig_description: Mapped[str | None] = mapped_column(String(1000))
    account_id: Mapped[int] = mapped_column(ForeignKey("account.account_id"))
    accounting_date: Mapped[date | None] = mapped_column(Date)

    account_rel: Mapped[Account] = relationship(back_populates="bank_transactions")
    spending_category: Mapped[SpendingCategory | None] = relationship(back_populates="transactions")
    splits: Mapped[list["CategorySplitDetail"]] = relationship(back_populates="parent_transaction")


class CategorySplitDetail(Base):
    __tablename__ = "category_split_detail"

    split_transaction_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    parent_transaction_id: Mapped[int | None] = mapped_column(ForeignKey("bank_transaction.transaction_id"))
    category_id: Mapped[int | None] = mapped_column(ForeignKey("spending_category.category_id"))
    split_amount: Mapped[Decimal | None] = mapped_column(Numeric(19, 4))

    parent_transaction: Mapped[BankTransaction | None] = relationship(back_populates="splits")
    spending_category: Mapped[SpendingCategory | None] = relationship(back_populates="splits")
