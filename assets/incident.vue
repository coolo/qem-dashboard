<template>
    <div class="col-md-12">
        <div class='smelt-link'>
        <h2>Link to smelt</h2>
        <p>
            <smelt-link v-bind:incident="incident" v-if="incident"/>
        </p>
        </div>

        <div class='incident-results' v-if="incident">
        <h2>Per incident results</h2>
        <p v-if="!incident.build_nr">No incident build found</p>
        <p v-else>
            {{ results }} - see details on <a v-bind:href="openqa_link">openqa</a>
        </p>
        </div>

        <h2 class="mb-3 mt-3">Aggregate runs including this incident</h2>
        <div class="container">
        <incident-build-summary v-for="build in sorted_builds"
            v-bind:key="build" v-bind:build="build" v-bind:jobs="jobs[build]"/>
        </div>
    </div>
</template>    

<script>
module.exports = {
  data: function() {
     return {
        incident: null,
        summary: null,
        jobs: []
     }
  },
  computed: {
    results: function() {
      let str = "";
      if (this.summary.passed) {
        str = this.summary.passed + " passed";
      }
      for (const [key, value] of Object.entries(this.summary)) {
        if (key == "passed")
          continue;
        if (str) {
          str += ", ";
        }
        str += value + " " + key;
      }
      return str;
    },
    openqa_link: function() {
        const searchParams = new URLSearchParams({build: this.incident.build_nr});
        return openqa_url + "?" + searchParams.toString();
    },
    sorted_builds: function() {
      return Object.keys(this.jobs).sort().reverse();
    }
  },
  methods: {
    loadData: function(number) {
      var self = this;
      // the format is not necessary for mojo, but import for 
      // chromium to keep the caches apart
      axios.get('/incident/' + number + "?_format=json").then(
        function(response) {
          self.incident = response.data.incident;
          self.incident.build_nr = response.data.build_nr;
          self.summary = response.data.incident_summary;
          self.jobs = response.data.jobs; 
        }
      );
    },
  }
}
</script>
