from pydantic import BaseModel, Field


class PayeeSuggestionOut(BaseModel):
    canonical_name: str
    observation_count: int
    source: str


class PayeeSuggestRequest(BaseModel):
    transaction_ids: list[int] = Field(min_length=1)


class PayeeApplyRequest(BaseModel):
    transaction_ids: list[int] = Field(min_length=1)
    canonical_name: str = Field(min_length=1)


class PayeeApplyResult(BaseModel):
    updated: int
    canonical_name: str


class PayeeAutocompleteItem(BaseModel):
    id: int
    canonical_name: str
