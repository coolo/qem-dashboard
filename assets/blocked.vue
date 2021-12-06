<template>
    <table class="table" v-if="incidents">
        <thead>
        <tr>
            <th>Incident</th>
            <th>Groups</th>
        </tr>
        </thead>
        <tbody>
        <tr is="blocked-incident"
            v-for="incident in incidents"
            v-bind:key="incident.incident.number"
            v-bind:incident="incident.incident"
            v-bind:incident_results="incident.incident_results"
            v-bind:update_results="incident.update_results"
            >
        </tr>
        </tbody>
    </table>
    <div v-else>
        Loading incidents...
    </div>
</template>

<script>
    module.exports = {
        data: function() { 
            return {incidents: null}
        },
        methods: {
            loadData: function() {
                var self = this;
                axios.get('/blocked?_format=json').then(
                    function(response) {
                    self.incidents = response.data;
                    }
                );
            },
        }
    }   
</script>