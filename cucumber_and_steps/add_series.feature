Feature: Add series
  In order to compare data
  As a user
  I want to add a series with specific data

  Background:
    Given I am logged in to account "elabs" as admin "cj@elabs.se"
    Given there is a report called "Profitability"

    @javascript @webrat
    Scenario: Adding a series with JavaScript enabled
      Given I am on the reports page
      When I follow "Profitability"
       And I follow "Add a series" and don't wait
       And I fill in "Name" with "Series 2"
       And I fill in "Formula" with "Profit / Revenue * 100"
       And I fill in "Period" with "2008"
       And I follow "Add Series" and don't wait
      Then I should be on the report "Profitability"
       And I should see a flash notice
       And I should see the series "Series 2"
      When I go to the report "Profitability"
      Then I should see the series "Series 2"