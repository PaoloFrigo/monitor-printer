# Monitor-Printer

## Printer Monitoring and Alerting Solution
Notes from skype chat 22/06/2020

## SCENARIO

An Autodoc HSE Printer (by streamlinesoftware.net) is installed on a window server and the number of printing jobs in the queue can grow during the day to few thousands.

Frequently the printer is rebooted to get it to function properly and users will submit the print jobs again.

## SOLUTION DESCRIPTION

Writing a script capable of monitoring the printer status and queue size and trigger Teams/Slack notification message if the number of jobs is bigger than a threshold value or if the printer is not in the desired state (e.g. ready/online).

## REQUIREMENTS

1. Reading the number of Jobs in the print queue for a specific printer.
2. Reading the status of a specific printer.
3. Setting up a threshold and desidered state to trigger notifications.
4. Trigger webhook notifications to slack/teams.
5. Notification message should include the __printer state__ and __size of the queue__.
6. Configurable printer name (or list of printer names).
7. Configurable thresholds value for the notification (queue size/state).
8. Configurable webhook url for Slack and Teams.
9. Exit values required for TaskSchelduler.