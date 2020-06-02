"""
Endpoint Module for handling spark triggering
Author: Po-Chun, Lu

"""
from flask_restful import Resource, reqparse

from endpoints.sample.args import add_post_args
from endpoints.logging import log_context


class Sample(Resource):
    """ /sample/

    """

    def __init__(self):
        self.model = None
        self._set_post_parser()

    def _set_post_parser(self):
        self.post_parser = reqparse.RequestParser()
        add_post_args(self.post_parser)

    @staticmethod
    def _post_operate(args):
        log_context("Request", f"{args}")

    def post(self):
        """ main handler of post request """
        args = self.post_parser.parse_args()
        self._post_operate(args)

        return {"info": "ok"}
