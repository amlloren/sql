# Assignment 1: Design a Logical Model

## Question 1
Create a logical model for a small bookstore. 📚

At the minimum it should have employee, order, sales, customer, and book entities (tables). Determine sensible column and table design based on what you know about these concepts. Keep it simple, but work out sensible relationships to keep tables reasonably sized. Include a date table. There are several tools online you can use, I'd recommend [_Draw.io_](https://www.drawio.com/) or [_LucidChart_](https://www.lucidchart.com/pages/).

## Question 2
We want to create employee shifts, splitting up the day into morning and evening. Add this to the ERD.

## Question 3
The store wants to keep customer addresses. Propose two architectures for the CUSTOMER_ADDRESS table, one that will retain changes, and another that will overwrite. Which is type 1, which is type 2?

_Hint, search type 1 vs type 2 slowly changing dimensions._

Bonus: Are there privacy implications to this, why or why not?
```
Your answer...
```
To help the store keep track of customer addresses, we first need to build a customer_address table. This customer_address table should include the following columns: customer_id, address, city, province, postal_code, and country.

If the store wants to retain all addresses for each customer then I would propose a Type 2 SCD architecture. This table would need the following columns:

address_id (INT, Primary Key)
customer_id (INT, Foreign Key referencing the CUSTOMER table)
Address (VARCHAR, Customer's address)
city, (VARCHAR, City)
province (VARCHAR, province)
postal_code (VARCHAR, postal code)
country (ARCHAR, Country)
start_date (DATE, Start date of this address)
end_date (DATE, End date of this address (NULL if current))

In this architecture, a new row is inserted every time a customer's address changes. The start_date indicates when the address became valid, and the end_date indicates when the address was replaced (NULL for the current address).

If the store does not want to retain older addresses then we need to use a Type 1 SCD that will overwrite the customer's address each time it changes. This table would need the following columns:

customer_id (INT, Foreign Key referencing the CUSTOMER table)
Address (VARCHAR, Customer's address)
city, (VARCHAR, City)
province (VARCHAR, province)
postal_code (VARCHAR, postal code)
country (ARCHAR, Country)
last_modified (TIMESTAMP, Timestamp of the last modification)

In this architecture, every time a customer's address changes, the new address will overwrite the old one, and the last_modified column is updated.

Bonus:

There are privacy implications for the Type 2 SCD design because it collects historical data of the customer’s addresses unlike the Type 1 SCD that deletes the old address when a new customer address is added. When considering privacy implications, storing historical addresses (Type 2) increases the risk of exposing personal data which means there is a need for strict access controls and compliance with privacy laws. There also needs to be a guideline for how long historical data is stored so that customer’s outdated information is deleted.

## Question 4
Review the AdventureWorks Schema [here](https://i.stack.imgur.com/LMu4W.gif)

Highlight at least two differences between it and your ERD. Would you change anything in yours?
```
Your answer...
```

There are a lot differences between my proposed ERD for the small bookstore with the AdventureWorks schema. The major differences that I noticed are the scope, table specialization and normalization as well as how data is handled. 

The AdventureWorks Schema is a lot more complicated to the bookstore ERD that I designed. The AdventureWorks schema is designed for a large-scale, comprehensive enterprise system that includes detailed sub-schemas like Sales, Purchasing, Person, Production, Human Resources and dbo. Each of these domains also have multiple tables that handle complex business processes. In contrast, my proposed ERD for the small bookstore is much simpler, with tables designed to manage core bookstore functions such as employees, customers, orders, sales, books, dates, and shifts. It focuses on a single business domain and keeps the schema straightforward and easy to manage.

Additionally, the schema employs a high level of normalization and specialization. For example, instead of a single Customer table, it separates tables for Person, BusinessEntity, and Contact, each with specific attributes and relationships. This helps in managing large volumes of data with detailed relationships. In contrast, my proposed ERD for the small bookstore has a single Customer table with all necessary attributes directly within it, simplifying the data model. It avoids high normalization levels to keep the design manageable for a small business scenario.

After studying the AdventureWorks Schema I got a couple ideas on how I can improve my proposed bookstore ERD. First, I can improve the customer data management by building multiple related tables such as customer, contact_info, and addresses tables instead of just one customer table with all these data. By doing this normalization we can streamline the data management and updates.

Another idea is to improve the order and sales data. We can shift from having just Order and Sales tables to a more detailed structure. Introducing additional tables like order_detail to capture each book in an order, similar to the detailed order processing in AdventureWorks. This would provide more granular tracking and better data organization. 

By incorporating some of the advanced structures from AdventureWorks, such as normalized customer data management and detailed order tracking, the bookstore database can be made more robust and flexible while balancing simplicity for small business needs.




# Criteria

[Assignment Rubric](./assignment_rubric.md)

# Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `September 28, 2024`
* The branch name for your repo should be: `model-design`
* What to submit for this assignment:
    * This markdown (design_a_logical_model.md) should be populated.
    * Two Entity-Relationship Diagrams (preferably in a pdf, jpeg, png format).
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sql/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `model-design`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via our Slack at `#cohort-4-help`. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
