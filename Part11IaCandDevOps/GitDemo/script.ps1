#open code in d:\scratch\storagerepo

Git --version  #(check healthy install)

Git config --global user.name "Your Name"
Git config --global user.email "your@email.com"
Git config --global --list

#copy in storage account arm template to subfolder ARMTemplates

#No git yet. Notice in source control tab offers to init the repo or publish to github
git init
#now have .git folder that stores all the information

cd ARMTemplates

#We now have our 3 key areas. The working tree (our folder),
#staging area (changes we want staged for next commit) and the history (our commits)

git status #shows untracked content

git add StorageAccount.json

git status #now shows as staged

#commit with comment (this is creating a new snapshot)
git commit -m "add the StorageAccount.json file"
#notice hash shown (first 7 characters)

git status

#detailed information on previous commits
git log
#better version to get overview of complete history
git log --oneline --decorate --graph --all
#make this easier to use again (and yes, bad verb I know :-))
function git-graph {git log --oneline --decorate --graph --all}

#notice we have the master (main) branch (default to snapshot) and a HEAD pointer
#HEAD pointer tells git what branch we are working on so as one branch points to master
#have the master branch checked out, can change this

#Change the template default replication and save
#note vscode is tracking there is now unstaged and could do from here, also can see diff in vscode
git status
git diff

#Lets stage
git add . #adds all files that are changed or new to staged
git diff --staged #changes between staged and latest commit
git commit -m "updated default replication type to GRS for StorageAccount.json file"
git-graph
git log
git log -p #see the changes then q to quit

#if had files to remove can do things like git rm <file> then commit etc
#can also checkout commits to restore etc

#add secrets.txt which i don't want in git (note use a vault instead)
git status
#add .gitignore to the folder and put in secrets.txt and save
git status
#notice in code secrets no longer tracked as well but add .gitignore
git add .
git commit -m ".gitignore file added"

#may want to work on something not in the master/main branch

#Can create a new branch to work on something
git branch zrswork
git-graph #notice zrswork points to same commit as master
git checkout zrswork #head now points to zrswork branch

#change json
git add .
git commit -m "updated to zrs" #will use this ZRS value later in deploy!!
git-graph #now we see we are ahead of master

#once happy we could fast-forward since its direct from master and no other changes
#if were other branches then would need a three-way merge which may have conflicts you would resolve

git checkout master
git diff master..zrswork
git merge zrswork #notice fast forward, if not would be recursive
git branch --merged #can see they are merged so can delete zrswork
git branch -d zrswork #now delete the unrequired branch as work complete

#integrate with github
cd ..
echo "# storagetemplate" >> README.md
git add README.md
git commit -m "added readme"
git remote add origin https://github.com/youraccount/yourrepo.git
git remote -v

#either
git push origin master #pushing to origin to remote master branch
#or BETTER which also sets the remote as the upstream remote so can just to get pull in future
git push -u origin master
#will make you authenticate since doing push the first time

git-graph
git remote show origin

git pull origin master #get any updates from remote

#Note in github have the code download which gives clone url so anyone can copy
