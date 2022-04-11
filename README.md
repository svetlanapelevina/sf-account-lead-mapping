# Assignment - Match Leads With Accounts

## Background

Account object’s standard Website field as well as Lead object’s standard Email field are configured as required fields 
in the system. To link Lead records to existing customer Accounts a custom Account lookup field on Lead and Lead related
list to Account view were added.

## Requirements

Field Marketing team is often uploading .csv files containing multiple leads from existing customer companies. 
Develop a process that would match the incoming Leads to the existing Accounts.
Mapping must be based on the Lead's Email domain and the Account's Website domain. 
We assume that the Website field on Account is unique.

## Solution

The following Salesforce declarative tools were used to implement this solution:
- Formula fields to get a domains from Email and Website fields,
- Flow to find an Account by domain and put it in the Lead's Account__c field.

### Formula Fields

The WebsiteDomain__c formula on Account object was added to simplify querying accounts by domain. It removes protocols 
(www, http, https) from the Website field. In the result only a domain left.

```
IF(
  CONTAINS(Website, "www."),
  SUBSTITUTE(Website, LEFT(Website, FIND(".", Website)), NULL),
  IF(
    BEGINS(Website, "http"),
    SUBSTITUTE(Website, LEFT(Website, FIND('//', Website) + 1), NULL),
    Website
  )
)
```

The EmailDomain__c formula on Lead object was added. It finds the '@' symbol in the Email field and returns a text after it.
It is used only for testing.

```
SUBSTITUTE(Email, LEFT(Email, FIND("@", Email)), NULL)
```

### Flow

To implement object mapping, a record-triggered flow was added. It contains 3 elements:
- The Get Records element that finds an account with WebsiteDomain__c equals to the Lead's Email domain. 
The Lead's Email domain is the flow variable that has the same formula as EmailDomain__c. 
EmailDomain__c formula will be not calculated in this flow since the record has not yet been saved in the database.
- The decision element that checks whether the found account is null.
- The Update Records element that fills in the Lead's Account__c field with the found account.

![flow](https://user-images.githubusercontent.com/45166039/162646321-1562f9e3-f5dc-4814-984b-b02d0de8bbeb.png)

## How to use

Go to Salesforce Setup, find Data Import Wizard and click Launch. When selecting data, enable **Trigger workflow rules and 
processes for new and updated records**. Follow all steps in the wizard and wait for the import job to be completed.

![wizard](https://user-images.githubusercontent.com/45166039/162646332-e82d5325-5c9e-4172-a2ce-0907f7fe6bc7.png)

### Tests

The table below shows leads with domains from sample Salesforce accounts and one with test
domain.

LastName | Email | Company
--- | --- | ---
Name1 | Name1@dickenson-consulting.com |  Company 1
Name2 | Name2@edgecomm.com | Company 2
Name3 | Name3@test.net | Company 3
Name4 | Name4@genepoint.com | Company 4
Name5 | Name5@grandhotels.com | Company 5
Name6 | Name6@pyramid.com | Company 6
Name7 | Name7@sforce.com | Company 7

Let's import these leads using Data Import Wizard. When the import job is finished, we see the result with 7 created
record.

![test-result](https://user-images.githubusercontent.com/45166039/162646343-ed026369-cee1-41fc-93ab-5d4065e10456.png)

Let's query these leads to check if Lead's Account field has been filled in. All leads were mapped with accounts except of the lead with the test domain.
It worked as expected.

![test-query-result](https://user-images.githubusercontent.com/45166039/162646352-20bfceb0-92bf-40f4-bf7b-2b27e4e1f73f.png)

## Test coverage

This repository contains a test class that covers the following cases:
- when the account was found,
- when the account was not found,
- when the lead's Email field is empty,
- when uploading a large number of leads.

Let's check the element's coverage for the flow:

![tests](https://user-images.githubusercontent.com/45166039/162646377-d547d91b-b158-410e-bcc4-286af1bae567.png)
