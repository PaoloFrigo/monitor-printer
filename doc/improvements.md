# Monitor-Printer

[ReadMe](../README.md) > [Requirements](requirements.md)

## Printer Monitoring and Alerting Solution

Notes from skype chat 20/07/2020

## Improvements

* Get notification for long printing jobs, regardless of the printing state and size of the queue.

Serialise the current job in a PRINTING state into an xml file.

```
 get-printjob -PrinterName "AutoDoc HSE" |
    Where-Object {$_.jobstatus -match "Printing"} |
    Select-Object computername, printername, jobstatus, id, documentname, pagesprinted, totalpages, size, username, submittedtime |
    Export-Clixml "last-printing-jobs.xml"
```

Re-Import the hash table and compare it to find if the job Id and SubmittedTime is still the same.

* Set a threshold value for long running jobs (e.g. More than 5 minutes).

* Set a filename variable for the exported last print job in a xml format.
