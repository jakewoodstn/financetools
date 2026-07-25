from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    database_url: str = "postgresql+psycopg://finance:finance@localhost:5432/finances"
    app_debug: bool = False
    app_timezone: str = "America/Chicago"
    simplefin_access_url: str | None = None

    @field_validator("app_debug", mode="before")
    @classmethod
    def parse_bool(cls, value: object) -> object:
        if isinstance(value, str):
            return value.strip().lower() in {"1", "true", "yes", "on"}
        return value
    @classmethod
    def strip_optional_str(cls, value: object) -> object:
        if isinstance(value, str):
            value = value.strip()
            return value or None
        return value

    @field_validator("database_url", mode="before")
    @classmethod
    def strip_str(cls, value: object) -> object:
        if isinstance(value, str):
            return value.strip()
        return value


settings = Settings()
