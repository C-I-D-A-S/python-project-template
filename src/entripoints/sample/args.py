"""
Module for API arguments config
Author: Po-Chun, Lu

"""


def add_post_args(post_parser):
    """ defining post arguments
    """
    post_parser.add_argument(
        "job_id",
        type=str,
        required=True,
        location="json",
        help="job_id parameter should be list",
    )
