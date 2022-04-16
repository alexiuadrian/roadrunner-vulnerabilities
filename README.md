# Roadrunner API

Simple Ruby on Rails API for managing your runs

---

## Dependencies
Language: ruby __3.0.2__  
Framework: rails __6.1.4.1__  
Database: postgresql

---

## How to run the project   

1. Install Ruby dependencies 
    ```bash
    bundle install
    ```

2. Configure the database
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

3. Start the server
    ```bash
    rails s
    ```


---

## API


### GET /api/runs

Response example:

```json
[
    {
        "id": 13,
        "date": "2022-11-06T00:00:00.000Z",
        "distance": 7.2,
        "time": "1 30",
        "average_speed": 4.8,
        "created_at": "2022-04-16T18:13:35.669Z",
        "updated_at": "2022-04-16T18:13:35.669Z",
        "user_id": 1
    }
]
```