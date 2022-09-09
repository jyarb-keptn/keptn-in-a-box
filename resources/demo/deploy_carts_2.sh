#!/bin/bash -x

keptn trigger delivery --project=sockshop --service=carts --image=keptnexamples/carts --tag=0.12.2 --labels=creator=cli,build=02

