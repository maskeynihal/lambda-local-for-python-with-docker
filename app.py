import json
import pandas as pd
import numpy as np


def handler(event, context):
    print("Received event: " + str(event))
    print("Context: " + str(context))

    """
    Send data in format of {body: <any>}
    While using AWS API gateway, don't have to pass the values in body, API itself sends the value in body.
    """

    rawBody = event.get("body", None)

    if not rawBody:
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "No body provided."}),
        }

    """
    Convert to json using json.loads(rawBody) to perform any operation on the body
    """
    # content = json.loads(rawBody)
    # Do something with content
    """
    Just random number generation using pandas
    """
    randomNumber = pd.Series(np.random.randint(0, 7, size=10)).to_json()

    return {
        "statusCode": 200,
        "body": {
            "input": rawBody,
            "randomNumber": randomNumber
        },
    }
