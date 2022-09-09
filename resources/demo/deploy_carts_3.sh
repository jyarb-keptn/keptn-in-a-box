#!/bin/bash -x

keptn trigger delivery --project=sockshop --service=carts --image=keptnexamples/carts --tag=0.12.3 --labels=creator=cli,build=03

