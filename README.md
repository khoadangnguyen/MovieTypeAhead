# MovieTypeAhead
Search-as-you-type implementation for movie titles with Bash and Elasticsearch.

This project demonstrates a small real-time autocomplete system for movie titles, leveraging Elasticsearch's indexing and 
search capabilities alongside a Bash-based interface. Movie titles are first pre-populated into "movies" index using 
Python. The data is then sourced into "autocomplete" index, where the title field is configured with the search_as_you_type
type to enable auto-completion. A custom Bash script allows users to input search text directly in the terminal. As 
users types, the script dynamically queries Elasticsearch and retrieves relevant suggestions, displaying them in real time.

![Start](./images/input.png)

![Example input and result](./images/input.png)


