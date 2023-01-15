let app = new Vue({
    el: '#app',
    data: {
        config: {
            projectName: 'Laboratory work №17',
            version: '0.1',
            lang: 'en',
            author: 'gjhonic',
        },
        //Метод
        url_get_tasks: '/v1/todos/list',
        //Данные
        tasksData: [],
        property: '',
    },
    computed: {
        Tasks() {
            return this.tasksData;
        },
        Branches() {
            return this.branchesData;
        },
    },
    methods: {
        loadTasks() {
            fetch(this.url_get_tasks, {
                method: "GET",
            }).then(response => response.json()).then(data => {
                this.tasksData = data;
                console.log(data);
            });
        },
    },
});
