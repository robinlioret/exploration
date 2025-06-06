## Configure Forgejo

With the following:

| Parameter                                               | Value                              |
| ------------------------------------------------------- | ---------------------------------- |
| Server domain                                           | sandbox.local                      |
| Base URL                                                | http://forgejo.sandbox.local:3000/ |
| Administrator account settings > Administrator username | administrator                      |
| Administrator account settings > Email address          | administrator@sandbox.local        |
| Administrator account settings > Password               | admin12345                         |

The clic on Install Forgejo.

## Get the gitops repository from GitHub

Create > New migration

Then "migrate" the repository of the associated gitops sample https://github.com/robinlioret/exploration-gitops.git. That wll be useful to test ArgoCD.

You can cloud this repo from the forgejo locally to edit and test stuff: `git clone http://forgejo.sandbox.local:3000/administrator/exploration-gitops.git`
