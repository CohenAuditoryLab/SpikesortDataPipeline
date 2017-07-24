# matToKiloSort

File Usage
----------
<ul>
<li><b>config</b> is run by matToKiloSort; sets the ops parameter required for KiloSort processing</li>
<li><b>createChannelMapFile</b> is run by matToKiloSort; creates a map of channel locations and groupings</li>
<li><b>createClusterGrid</b> is run by graphSpikes; updates a given figure to include graphs of a given cluster's spikes</li>
<li><b>getRawWaveforms</b> is run by graphSpikes; parses the binary specified in rez for waveforms surrounding spikes</li>
<li><b>graphSpikes</b> is run by matToKiloSort; creates graphs of spikes for all clusters and either displays or saves them</li>
<li><b>matToKiloSort</b> is run by pipelineRunner; runs the KiloSort algorithm on a given binary, saves cluster graphs, and outputs phy files</li>
</ul>

<b>graphSpikes</b> and <b>matToKiloSort</b> may be run individually, outside the constraints of the pipeline. Depending on the number of arguments, graphSpikes can be used to display cluster graphs of spikes or save them, overwriting previously saved cluster graphs of spikes.
