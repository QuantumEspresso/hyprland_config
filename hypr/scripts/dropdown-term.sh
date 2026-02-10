#!/usr/bin/env sh

if [[ -z "$1" ]]; then
	exit
fi

term_pid=$(hyprctl clients | awk "BEGIN{flag=0}{if(\$3==\"(special:$1)\"){flag=1};if(\$1==\"pid:\" && flag==1){print \$2;exit}}")
if [[ -n "$term_pid" ]]; then
	#get current screen width, height and position and scale
	monitor=$(hyprctl monitors all | awk '{if($2=="at"){out=$0};if($1=="focused:" && $2=="yes"){print out}}')
	monitor_scale=$(hyprctl monitors all | awk '{if($1=="scale:"){out=$2};if($1=="focused:" && $2=="yes"){print out}}')

	# get teminal posiotion
	term_loc=$(hyprctl clients | awk "{if(\$1==\"at:\"){out=\$2};if(\$3==\"(special:$1)\"){print out}}")
	# get terminal size
	term_size=$(hyprctl clients | awk "{if(\$1==\"size:\"){out=\$2};if(\$3==\"(special:$1)\"){print out}}")
	
	#extract values from screen
	monitor_width=$(echo $monitor | awk -F'[ x@]' '{print $1}')
	monitor_height=$(echo $monitor | awk -F'[ x@]' '{print $2}')
	monitor_x=$(echo $monitor | awk -F'[ x@]' '{print $5}')
	monitor_y=$(echo $monitor | awk -F'[ x@]' '{print $6}')

	#extract values from window
	term_width=$(echo $term_size | awk -F',' '{print $1}')
	term_height=$(echo $term_size | awk -F',' '{print $2}')
	term_x=$(echo $term_loc | awk -F',' '{print $1}')
	term_y=$(echo $term_loc | awk -F',' '{print $2}')
  bar_offset=40

	#calculate how much to move and resize window
	new_x=$((monitor_x - term_x))
	new_y=$((monitor_y - term_y + bar_offset))

	new_width=$(echo "$monitor_width / $monitor_scale - $term_width" | bc | cut -d"." -f 1)
	new_height=$(echo "$monitor_height / $monitor_scale / 2 - $term_height" | bc | cut -d"." -f 1)

	#move and resize window
	#hyprctl dispatch "movewindowpixel $new_x $new_y,^(kitty)$"
	#hyprctl dispatch "resizewindowpixel $new_width $new_height,^(kitty)$"
	hyprctl dispatch "movewindowpixel $new_x $new_y,pid:$term_pid"
	hyprctl dispatch "resizewindowpixel $new_width $new_height,pid:$term_pid"

fi
#toggle special workspace
hyprctl dispatch togglespecialworkspace $1


