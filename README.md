geo-prescriptions
=================

Geomapping GP prescriptions during Open Healthcare Data Hackathon 2014 by Data Science London

More details at
http://lev.ghost.io/2014/12/15/healthcare-hackathon-by-data-science-london-ohdh14/


Last weekend I attended [Healthcare Hackathon](http://healthcaredatascience.com/) organised by London Data Science. 

Here are some maps created by our team: 

["Diarrhea in Mayfair"](http://lev.ghost.io/diarea/)
<iframe width="800" height="800" scrolling="no" frameborder="no" src="https://www.google.com/fusiontables/embedviz?q=select+col7+from+1OSQhQoUaZexjSTNjDB7JqFpRpuH5G09wstKGxkc0&amp;viz=MAP&amp;h=false&amp;lat=52.948513687467596&amp;lng=0.14453481250006917&amp;t=1&amp;z=7&amp;l=col7&amp;y=2&amp;tmplt=2&amp;hml=GEOCODABLE"></iframe>

["Only middle class people demand antidepressants"](http://lev.ghost.io/depression/)
<iframe width="800" height="800" scrolling="no" frameborder="no" src="https://www.google.com/fusiontables/embedviz?q=select+col0+from+1jjF65nnHA1i3KeHqPxYnZYtsHHGBdRpdDRZ1nm5P&amp;viz=MAP&amp;h=false&amp;lat=51.515251884655456&amp;lng=-0.1051743542479926&amp;t=1&amp;z=13&amp;l=col0&amp;y=2&amp;tmplt=2&amp;hml=GEOCODABLE"></iframe>



Our code on [github](https://github.com/tmylk/geo-prescriptions/)


######Hackathon experience

It was my first hackathon so I didn’t know what to expect. The conditions were actually very comfortable.  Cool space - white and airy HUB Westminster with angular desk arrangements. We picked a real glass greenhouse to work in a 5 people team.  Granola breakfast, pret sandwiches and domino’s pizza made a good fare.  Twenty people stayed overnight, but majority went home.



######The dataset


My first programming job was for pharmaceutical sales representatives in Russia: a DB and UI to record which doctor they visited, which drugs they talked about and whether it had an effect on sales.

So I was naturally interested in the UK GP prescriptions [dataset](http://www.hscic.gov.uk/gpprescribingdata). 

[![HSCIC](http://www.hscic.gov.uk/hscic/images/toplogo.gif)](http://www.hscic.gov.uk/gpprescribingdata)

The data is freely available to download. A  typical month CSV is 10m records and a size of 1GB.

Records are of format GP Practice id, Drug id (British National Formulary code) and Processing date.

Initial idea was to create a map of UK divided into regions of sales rep activity – this is Pfizer area, that one is Novartis. When everyone was milling around and splitting into teams I was lucky to run into Luis who already scraped the EMA drug list by manufacturer after reading “Bad Pharma” book, so of course we have teamed up!

Unfortunately it turned out that the data only has the chemical information but not the manufacturer info – the BNF codes are cut to 9 digits and don’t include the manufacturer spec digits 15-16.

New idea was to create maps of UK where people are prescribed medicines for specific conditions and correlate it with socioeconomic stats for the area.

######What condition is the prescription for?

![BNF](http://www.pharmpress.com/productimages/BNF68_3D.jpg)Every prescription has BNF code like 0102038A which references a page in a book British National Formulary. The first 2 digits are Chapter (e.g. Gastro, Blood, skeleton). Digits 3-4 are Section (e.g. Dyspepsia, Minerals, Rheumatism).



We were lucky that there was no need to scrape the online book – it is available in JSON thanks to [OpenBNF project]( https://github.com/nhshackday/mobileformular) from NHS Hackday 2012.

It is great to see that opening one piece of data allows to make many more connections.

######Aggregating by top level postcode

There are two ways to view the data – by GP practice and by county. County is not granular enough for correlation with socioeconomic status – for example Kent is quite a varied area.

GP practice area looked more promising. There is a section of the dataset specifying full UK postcode for each GP practice.

Full UK postcode is a bit too granular to put on a map – just the KML file defining their area shape is 2Gb, so we needed to aggregate by top level postcode. [Top level postcode KML](http://www.doogal.co.uk/KmlDataFeeds.php&v=3) is only 10Mb from 

What to do if there are 5 GP practices in NW3 of different sizes?

Take an average weighted by practice size(weighted_demographic table).

Link with [Public Health England](http://fingertips.phe.org.uk/profile/general-practice/data) dataset by practice id allowed to see number of patients per practice. It also has Multiple Deprivation Index and Unemployment figures that came in handy.



######Normalising to per capita values

Initial map showed us just big cities – areas with great population density and thus high prescription amounts. Therefore we needed to normalise per capita – gladly we had practice size data already.

######Linking with socioeconomic data

When one thinks of socioeconomic data first thing that comes to mind is using the census. Unfortunately the census is by MSOA and our data is by postcode. There is MSOA KML  but translating them into postcode seemed hard work.

Fortunately, the Public Health England dataset had the info per GP practice so we took it from there.

######Demo

After all this munging and aggregating, we managed to get to the interesting data analysis/visualisation bit only 2 hours before the end of the hackathon. So what are we going to demo? It was enough to pick one condition and stick it into a Google Fusion Table. 

What one condition would you pick?

[Acute diarrhaea plotted across UK in a nice brown colour scheme.](http://lev.ghost.io/diarea/)

There was even a nugget in there - Mayfair a is a hotspot for the month we randomly picked August 2013.
Later added Anti-depressants map that might support the stereotype that well-to-do people demand more antidepressants. Though a proper stats correlation computation would be better. And why is there missing data on that map? Where are the midlands?

######Where to go from here

We now have enough data for 92 maps – one for each section of BNF and 2 socioeconomic indicators. Putting them manually into Fusion Tables is not an option. When I learn more javascript I might make a page invoking Google maps or OpenStreet API based on BNF section selection.

A webapp by postcode is another idea – knowing what people suffer from in the area would help you choose a place to live. It is just as useful as school info in Zoopla.

Also, analysing more months and watching a video of hay fever spreading North would be great.

######Limitations

We only analysed one month August 2013. We have a lot of missing postcodes on the maps for the two conditions we did – would be interesting to know why.

######Issues

One of the goals of the hackathon was to play with Azure ML –there were plenty of Azure ML engineers helping out at the event. We tried dumping a 1GB 10m rows CSV into an Azure ML Reader. Two hours was a bit too slow so the exploration was over then. Maybe if we had data and processing in the same Azure datacenter it could have worked ok.  Anyway we switched to AWS - the dataset was already in S3 thanks to the organisers and Dan has spun up an a Postgres instance in a flash with extra large storage.
