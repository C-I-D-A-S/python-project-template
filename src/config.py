"""
Module of flask config
Author: Po-Chun, Lu

"""
import os


class Config:
    """Parent configuration class."""

    DEBUG = False
    CSRF_ENABLED = True
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DB_URL", "postgresql:sample_user//:sample_pw@localhost:5432/example"
    )
    TIME_ZONE = os.environ.get("TIME_ZONE", 8)


class DevelopmentConfig(Config):
    """"configuration class for dev env"""

    DEBUG = True


class TestingConfig(Config):
    """"configuration class for testing env"""

    TESTING = True
    DEBUG = True


class StagingConfig(Config):
    """"configuration class for staging env"""

    DEBUG = True


class ProductionConfig(Config):
    """"configuration class for prod env"""

    DEBUG = False
    TESTING = False


APP_CONFIG = {
    "development": DevelopmentConfig,
    "testing": TestingConfig,
    "staging": StagingConfig,
    "production": ProductionConfig,
}
