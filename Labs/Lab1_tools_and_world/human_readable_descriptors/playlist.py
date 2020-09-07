# %% Import what we need

import os
import json
import time
import requests

os.chdir(os.path.abspath(os.path.dirname(__file__)))
import your_code
CREATE_SPOTIFY_PLAYLIST = True # Set it to "no" and I will create a long file instead
# %% Get the token
# 1) go to https://developer.spotify.com/console/post-playlists/
# 2) press "try it"
# 3) remember to include playlist-modify-private 
# 4) login
# 5) agree 
# 6) execute this cell and give the script the token (see above)
if "token" not in locals(): # if you have not inserted the token 
    token=input("Give me the token")
header={"Authorization": "Bearer %s"%token}


# %% Search the songs

assert os.path.exists("list_of_songs.json"), "Please put here a list of songs"
with open("list_of_songs.json",'r') as fp:
    songs=json.load(fp)["songs"]

# %% Get the audio features
search_url="https://api.spotify.com/v1/search"
audio_feature_url="https://api.spotify.com/v1/audio-features"
audio_features=[]

for song in songs:
    params={"q": song["artist"]+" "+song["title"], "type": "track"}
    req=requests.get(url=search_url, params=params,headers=header)
    assert req.status_code==200, req.content
    answer=req.json()    
    results=answer["tracks"]["items"]
    if len(results)==0:
        print("I couldn't find %s"%params["q"])
        continue    
    params={"ids":results[0]["id"]}
    req=requests.get(url=audio_feature_url, params=params, headers=header)
    assert req.status_code==200, req.content
    audio_features_song=req.json()["audio_features"][0]
    audio_features_song["title"]=results[0]["name"]
    audio_features_song["artist"]=results[0]["artists"][0]["name"]
    audio_features_song["preview_url"]=results[0]["preview_url"]
    audio_features.append(audio_features_song)
    time.sleep(1) # wait 1 second between the questions
# %% Now let's create some way to organize them!

shuffled_songs=your_code.sort_songs(audio_features)

# %% Create the playlist
# Go to https://open.spotify.com/ , top right corner, press "Account"
# look at your username or user_id
name_playlist=input("What's the name of the playlist you want to create?")
user_id=input("What's your username?")

params={"name":name_playlist, "description": "made during cpac!"}


# %% Actually create the playlist
create_playlist_url="https://api.spotify.com/v1/users/{user_id}/playlists".format(user_id=user_id)
req=requests.post(url=create_playlist_url, json=params, headers=header)
assert req.status_code==201, req.content
playlist_info=req.json()
print("Playlist created with url %s"%playlist_info["external_urls"]["spotify"])
# %% Populating the playlist
# Doc at https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/
add_item_playlist_url="https://api.spotify.com/v1/playlists/{playlist_id}/tracks".format(playlist_id=playlist_info["id"])
uris=[]
for song in shuffled_songs:
    uris.append(song["uri"])
params={"uris":uris, }
req=requests.post(url=add_item_playlist_url, json=params, headers=header)
assert req.status_code==201, req.content
playlist_info_songs=req.json()

