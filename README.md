# Let's Post It
[![Build Status](https://travis-ci.org/emn178/js-md5.svg?branch=master)](https://travis-ci.org/dannyh79/lets_post_it)

A Rails app for task management

---
## Ruby & Rails Version
- Ruby: `2.6.0`
- Rails: `5.2.3`

## ER Diagram
![ERD](https://images2.imgbox.com/89/f0/0cKkgDPd_o.jpg)

## Table Schema
- users

  |Column|Data Type|
  |--|--|
  |id|*integer*| 
  |email|*string*| 
  |password|*string*| 
  |role|*string*| 

- tasks

  |Column|Data Type|
  |--|--|
  |id|*integer*| 
  |user_id|*integer*| 
  |title|*string*| 
  |start_time|*datetime*| 
  |end_time|*datetime*| 
  |priority|*integer*| 
  |status|*integer*| 
  |description|*text*| 
  
- tags

  |Column|Data Type|
  |--|--|
  |id|*integer*| 
  |name|*string*| 
  |title|*string*| 

- tags_tasks (join table for "tags" and "tasks")

  |Column|Data Type|
  |--|--|
  |id|*integer*| 
  |tag_id|*integer*| 
  |task_id|*integer*| 


## Getting Started (WIP)
- 以 `rails db:create` 建立資料庫
- 以 `rails db` 確認有正確連接資料庫

## Running the Automated Test Suite
- `$ bundle exec guard`

## Deploying the App onto Heroku
1. Create a Heroku account
2. Download & install the Heroku CLI
  > Mac OS users can download/install Heroku CLI via Homebrew from Terminal:
  >> `$ brew tap heroku/brew && brew install heroku`
3. Under the app's directory, run `$ heroku create` to create a Heroku app
4. `$ git remote -v` to confirm that a remote named heroku has been set for the app
5. `$ git push heroku master` to push the code onto Heroku from master branch
6. `$ heroku run bundle`
7. `$ heroku db:create`
8. `$ heroku rails db:migrate`
9. (optional) Renaming the app: `$ heroku apps:rename new_name --app old_name`
