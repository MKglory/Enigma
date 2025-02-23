# Name: Chengkai Lin
# SBU ID#: 113499548
# Assignment #1

#!/bin/bash

# All component arributes
Initialization(){
    reflector_A="EJMZALYXVBWFCRQUONTSPIKHGD"
    reflector_B="YRUHQSLDPXNGOKMIEBFZCWVJAT"
    reflector_C="FVPJIAOYEDRZXWGCTKUQSBNMHL"

    # rotor_1="EKMFLGDQVZNTOWYHXUSPAIBRCJ"
    rotor_1=(E K M F L G D Q V Z N T O W Y H X U S P A I B R C J)
    notch_1='Q'
    # rotor_2="AJDKSIRUXBLHWTMCQGZNPYFVOE"
    rotor_2=(A J D K S I R U X B L H W T M C Q G Z N P Y F V O E)
    notch_2='E'
    # rotor_3="BDFHJLCPRTXVZNYEIWGAKMUSQO"
    rotor_3=(B D F H J L C P R T X V Z N Y E I W G A K M U S Q O)
    notch_3='V'
    # rotor_4="ESOVPZJAYQUIRHXLNFTGKDCMWB"
    rotor_4=(E S O V P Z J A Y Q U I R H X L N F T G K D C M W B)
    notch_4='J'
    # rotor_5="VZBRGITYUPSDNHLXAWMJQOFECK"
    rotor_5=(V Z B R G I T Y U P S D N H L X A W M J Q O F E C K)
    notch_5='Z'

    # A array for all 26 alphabet
    alphabet_array=({A..Z})

}
rotors_set_up(){
    local string="$1"
    string=$(echo "$string" | tr [:lower:] [:upper:])
    reflector="${string:0:1}"
    case $reflector in
    A)
        reflector="${reflector_A}"
        ;;
    B)
        reflector="${reflector_B}"
        ;;
    C)
        reflector="${reflector_C}"
        ;;
    esac
    # reflector="$reflector_B"

    # Initialize all encrypt componnents
    rotorI="${string:1:1}"
    case $rotorI in 
    1)
        rotorI=("${rotor_1[@]}")
        rotorI_notch=("$notch_1")
        ;;
    2)
        rotorI=("${rotor_2[@]}")
        rotorI_notch=("$notch_2")
        ;;
    3)
        rotorI=("${rotor_3[@]}")
        rotorI_notch=("$notch_3")
        ;;
    4)
        rotorI=("${rotor_4[@]}")
        rotorI_notch=("$notch_4")
        ;;
    5)
        rotorI=("${rotor_5[@]}")
        rotorI_notch=("$notch_5")
        ;;
    esac
    # rotorI=("${rotor_1[@]}")
    # rotorI_notch=("$notch_1")

    rotorII="${string:2:1}"
    case "$rotorII" in
    1)
        rotorII=("${rotor_1[@]}")
        rotorII_notch=("$notch_1")
        ;;
    2)
        rotorII=("${rotor_2[@]}")
        rotorII_notch=("$notch_2")
        ;;
    3)
        rotorII=("${rotor_3[@]}")
        rotorII_notch=("$notch_3")
        ;;
    4)
        rotorII=("${rotor_4[@]}")
        rotorII_notch=("$notch_4")
        ;;
    5)
        rotorII=("${rotor_5[@]}")
        rotorII_notch=("$notch_5")
        ;;
    esac
    # rotorII=("${rotor_2[@]}")
    # rotorII_notch=("$notch_2")

    rotorIII="${string:3:1}"
    case "$rotorIII" in
    1)
        rotorIII=("${rotor_1[@]}")
        rotorIII_notch=("$notch_1")
        ;;
    2)
        rotorIII=("${rotor_2[@]}")
        rotorIII_notch=("$notch_2")
        ;;
    3)
        rotorIII=("${rotor_3[@]}")
        rotorIII_notch=("$notch_3")
        ;;
    4)
        rotorIII=("${rotor_4[@]}")
        rotorIII_notch=("$notch_4")
        ;;
    5)
        rotorIII=("${rotor_5[@]}")
        rotorIII_notch=("$notch_5")
        ;;
    esac
    # rotorIII=("${rotor_3[@]}")
    # rotorIII_notch=("$notch_3")

    rotorI_pos="${string:4:1}"
    rotorI_val=$(find_index "$rotorI_pos" "${alphabet_array[@]}") # convert to corresponding number
    rotorII_pos="${string:5:1}"
    rotorII_val=$(find_index "$rotorII_pos" "${alphabet_array[@]}")
    rotorIII_pos="${string:6:1}"
    rotorIII_val=$(find_index "$rotorIII_pos" "${alphabet_array[@]}")
}
plugboard_set_up(){
    local string="$1"
    string=$(echo "$string" | tr [:lower:] [:upper:])
    IFS=',' read -r -a array <<< "${string}"
}
plugboard(){
    char="$1"
    for pair in "${array[@]}"; do
        if [[ "$char" == "${pair:0:1}" ]]; then
            echo "${pair:1:1}"
            return
        elif [[ "$char" == "${pair:1:1}" ]]; then
            echo "${pair:0:1}"
            return
        fi
    done
    echo "$char"
}
# Simulated the key down, rotors rotate
key_clicked(){
    reach_notch=false
    # rotate the most right rotor
    rotorIII_val=$(((rotorIII_val + 1) % 26))
    rotorIII_pos="${alphabet_array["$rotorIII_val"]}"
    if [[ "$rotorIII_pos" == "$rotorIII_notch" ]]; then
        reach_notch=true
    fi

    # rotate the middle rotor
    if [[ "$reach_notch" == true ]]; then
        rotorII_val=$(((rotorII_val + 1) % 26))
        rotorII_pos="${alphabet_array["$rotorII_val"]}"
        if [[ "$rotorII_pos" == "$rotorII_notch" ]]; then
            reach_notch=true
        else
            reach_notch=false
        fi
    fi
    #rotate the most left rotor
    if [[ "$reach_notch" == true ]]; then
        rotorI_val=$(((rotorI_val + 1) % 26))
        rotorI_pos="${alphabet_array["$rotorI_val"]}"
    fi
}
# Functino to find the index given of given character
find_index(){
    local char=$1
    shift
    local array=("$@")

    for (( i=0; i<"${#array[@]}"; i++ )); do
        if [[ "${array["$i"]}" == "$char" ]]; then
            echo "$i"
            return 0
        fi
    done
    return 1
}
# fist time pass through rotors
first_pass(){
    local input="$1"
    local input_num=$(find_index "$input" "${alphabet_array[@]}")

    # the most right rotor:
    # Apply Rotor shift
    input_num=$(((input_num + rotorIII_val) % 26))
    local encrypted="${rotorIII[$input_num]}"
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    # echo "$encrypted" # output for rotor III

    # Adjust back for Rotor position
    input_num=$(((input_num - rotorIII_val + 26) % 26))
    # the middle rotor
    # Apply Rotor shift
    input_num=$(((input_num + rotorII_val) % 26))
    input=${alphabet_array[$input_num]} # input for rotor II
    # echo $input
    input_num=$(find_index "$input" "${alphabet_array[@]}")
    encrypted="${rotorII[$input_num]}"
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    # echo $encrypted

    # Adjust back for Rotor position
    input_num=$(((input_num - rotorII_val + 26) % 26))
    # The most left rotor
    # Apply Rotor shift
    input_num=$(((input_num + rotorI_val) % 26))
    input=${alphabet_array[$input_num]} # input for rotor I
    # echo $input

    input_num=$(find_index "$input" "${alphabet_array[@]}")
    encrypted="${rotorI[$input_num]}"
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    # echo $encrypted

    # Adjust back for Rotor position
    input_num=$(((input_num - rotorI_val + 26) % 26))
    input=${alphabet_array[$input_num]} # input for reflector
    # echo $input
    # Go to reflector
    input_num=$(find_index "$input" "${alphabet_array[@]}")
    encrypted=${reflector:$input_num:1}
    echo $encrypted
}
second_pass(){
    local input="$1"
    # echo $input
    local input_num=$(find_index "$input" "${alphabet_array[@]}")

    # apply the most left rotor
    # Apply Rotor shift
    input_num=$(((input_num + rotorI_val) % 26))
    input=${alphabet_array[$input_num]} # input for rotor I in reverse
    # echo $input
    input_num=$(find_index "$input" "${rotorI[@]}")
    local encrypted="${alphabet_array[$input_num]}"
    # echo $encrypted

    # Adjust back for Rotor position
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    input_num=$(((input_num - rotorI_val + 26) % 26))

    # the middle rotor
    # Apply Rotor shift
    input_num=$(((input_num + rotorII_val) % 26))
    input=${alphabet_array[$input_num]}  # input for rotor II in reverse
    # echo $input
    input_num=$(find_index "$input" "${rotorII[@]}")
    local encrypted="${alphabet_array[$input_num]}"
    # echo $encrypted

    # Adjust back for Rotor position
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    input_num=$(((input_num - rotorII_val + 26) % 26))

    # Apply the most right rotor
    # Apply Rotor shift
    input_num=$(((input_num + rotorIII_val) % 26))
    input=${alphabet_array[$input_num]}  # input for rotor II in reverse
    # echo $input
    input_num=$(find_index "$input" "${rotorIII[@]}")
    local encrypted="${alphabet_array[$input_num]}"

    # Adjust back for Rotor position
    input_num=$(find_index "$encrypted" "${alphabet_array[@]}")
    input_num=$(((input_num - rotorIII_val + 26) % 26))
    encrypted=${alphabet_array[$input_num]}

    echo $encrypted
}

# Enigma Machine
encrypt(){
    local input="$1"
    input="$(plugboard "$input")"
    local encrypted=$(first_pass "$input")
    #reverse
    input="$encrypted"
    encrypted=$(second_pass "$input")
    encrypted="$(plugboard "$encrypted")"
    echo "$encrypted"
}

is_alphabet(){
    char_to_check="$1"
    found=false

    for char in "${alphabet_array[@]}"; do
        if [[ "$char" == "$char_to_check" ]]; then
            found=true
            break
        fi
    done

    if $found; then
        echo true
    else
        echo false
    fi

}
enigma_Machine(){
    plaintext="$1"
    length=${#plaintext}
    # Convert all into uppercase character
    uppercase_plaintext=$(echo "$plaintext" | tr [:lower:] [:upper:])
    ciphertext=""
    for (( i=0; i<length; i++ )); do
        char="${uppercase_plaintext:i:1}"
        if [[ $(is_alphabet "$char") == true ]]; then
            key_clicked # Simulating key pressed
            char=$(encrypt "$char")
        fi
        ciphertext="${ciphertext}${char}"
    done
    echo "${ciphertext}"
}

main(){
    Initialization
    # first line
    while true; do
        # read -p "Enter a letter (A/B/C) for reflector, numbers for three rotors, and each rotor's starting position: " firstLine
        read firstLine

        if [[ ${#firstLine} == 7 ]]; then
            rotors_set_up  "${firstLine}"
            break
        else
            echo "Invalid arguments"
        fi
    done
    # second line
    # read -p "Provide the plugboard connection if the form of comma-separated character pairs: " secondLine
    read secondLine

    plugboard_set_up "${secondLine}"

    # third line
    # read -p "Enter a plaintext: " plaintext
    read plaintext
    enigma_Machine "$plaintext"
}

main

