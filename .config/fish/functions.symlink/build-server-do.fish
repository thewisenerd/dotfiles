function build-server-do
	if [ "$argv" = "" ];
		echo "say something <.<"
		return
	end

	set zone "asia-southeast1-a"
	set mach "build-machine"

	switch $argv
	case start
		gcloud compute instances start --zone $zone --quiet $mach
	case stop
		gcloud compute instances stop --zone $zone --quiet $mach
	case describe
		gcloud compute instances describe --zone $zone $mach
	case ssh
		gcloud compute ssh --zone $zone $mach
	case '*'
		echo Hi, stranger!
	end
end
