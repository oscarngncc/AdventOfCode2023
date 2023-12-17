# Advent Of Code 2023

☃️ Advent of Code 2023, but in freaking Terraform/HCL, because why not!

## Prerequisite: 

* Terraform Version >=1.6 is required in order to run terraform test

## Run:

under the target directory (e.g. `Day1_Terbuchet/Par1/Terraform`), create and drop the input file named `test_input.txt`, then run:

```
terraform plan
```

which should give you the result. Certain result may require additional steps (e.g. `terraform console` and paste the input to evaluate the expression).

## Test

It's always good practice to write unit tests 😊 to validate your code first before submitting the answer.

To run a test of a particular part of the day, go to the target directory via `cd Day1_Terbuchet/Par1/Terraform` and run

```
terraform test
```

To Run all test cases, go to the repo root directory and run:

```
find . -name Terraform -exec terraform -chdir={} test \;
```