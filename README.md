# Advent Of Code 2023

☃️ Advent of Code 2023, but in freaking Terraform/HCL, because why not!

## Prerequisite: 

* Terraform Version >=1.6 is required in order to run terraform test

## Progress

|      | Part-1 | Sidenote | Part-2 | Sidenote |
|------|--------|----------|--------|----------|
| Day1 | ✔️      | /        | ✔️      | /        |
| Day2 | ✔️      | /        | ✔️      | /        |
| Day3 | ✔️      | /        | ✔️      | 📚        |
| Day4 | ✔️      | /        | ✔️      | ♾️        |
| Day5 | ✔️      | /        | ✔️      | ♾️        |
| Day6 | ✔️      | 📚        | ✔️      | ♾️        |
| Day7 | ✔️      | /        | ✔️      | /        |
| Day8 | ✔️      | ♾️        |        |          |


The following symbols in side note means the following:

* 📚 Requires copying the result string expression and paste it to `terraform console`
* ♾️ Requires `terraform init`, then `terraform apply` (not plan) multiple times. No applied changes once reaching the end.

## Run:

For most solutions, simply go to the target directory (e.g. `Day1_Terbuchet/Par1/Terraform`), create and drop the input file named `test_input.txt`, then run:

```
terraform init
terraform plan
```

that should give you the result, unless specified in Side-note

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