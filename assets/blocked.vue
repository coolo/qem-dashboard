<template>
    <div v-if="incidents">
        <div class="float-right">
            <input type="checkbox" id="checkbox" v-model="groupFlavors">
            <label for="checkbox">Group Flavors</label>
        </div>
        <table class="table">
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
                v-bind:incidentResults="incident.incident_results"
                v-bind:updateResults="incident.update_results"
                v-bind:groupFlavors="groupFlavors"
                >
            </tr>
            </tbody>
        </table>
    </div>
    <div v-else>
        Loading incidents...
    </div>
</template>

<script>
    module.exports = {
        data: function() { 
            return {
                incidents: null,
                groupFlavors: true,
            }
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