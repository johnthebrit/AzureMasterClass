#need a service principal for GitHub Actions to use to authenticate and run as
az ad sp create-for-rbac --name "http://githubactions" --role contributor --scopes /subscriptions/466c1a5d-e93b-4138-91a5-670daf44b0f8/resourceGroups/savdevgithubdeploy --sdk-auth

#can see it under aad - app registrations (all) and has permissions on resource group

#AZURE_CREDENTIALS secret name

git fetch origin #pulls but does not merge
git-graph #shows ahead on origin now
git merge origin/master #will fast forward

#or to fetch and merge in one go could have used
git pull origin master

git add .
git commit -m "updated deploy.yml file"
git push origin master
#should kick off under actions straight away!
#click on workflow - deploy to see all detail