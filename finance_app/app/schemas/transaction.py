from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class TransactionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    transaction_id: int = Field(validation_alias="transaction_id")
    transaction_date: date | None
    accounting_date: date | None
    description: str | None
    category_id: int | None
    category_name: str | None = None
    amount: Decimal | None
    bank_orig_description: str | None
    account_id: int
    account_name: str | None = None
    category_status: int
    tags: str | None = None
    tag_count: int | None = None
    is_split: bool = False


class CategoryOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    category_id: int
    category_name: str
    group_id: int


class TagOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    tag_id: int
    tag: str


class AssignCategoryRequest(BaseModel):
    transaction_ids: list[int] = Field(min_length=1)
    category_id: int


class AssignCategoryResult(BaseModel):
    updated: int
    category_id: int
    category_name: str | None = None
