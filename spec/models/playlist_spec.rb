require 'rails_helper'

RSpec.describe Playlist, type: :model do
  describe 'validations' do
    it 'must have a name' do
      user = User.create(username: 'Bennet Foddley', password: 'password123')
      playlist = user.playlists.new()

      expect(playlist).to_not be_valid
    end

    # TODO validate that must have at least 1 user.
    xit 'must belong to a user' do
      playlist = Playlist.create(name: 'Road')

      expect(playlist).to_not be_valid
    end

    it 'is valid with all attributes' do
      user = User.create(username: 'Bennet Foddley', password: 'password123')
      playlist = user.playlists.create(name: 'Road')


      expect(playlist).to be_valid
    end
  end

  describe 'relationships' do
    it 'can have many songs' do
      playlist = Playlist.new(name: 'Road')
      song1 = Song.create(name: 'On the Road Again')
      song2 = Song.create(name: 'Hit the Road Jack')
      playlist.songs  << song1
      playlist.songs << song2

      expect(playlist).to respond_to(:songs)
      expect(playlist.songs).to eq([song1, song2])
    end

    it 'has many users' do
      playlist = Playlist.create(name: 'Road')
      user1 = User.create(username: 'Bennet Foddley', password: 'password123')
      user2 = User.create(username: 'Nobunaga', password: 'password123')
      user3 = User.create(username: 'Phinks', password: 'password123')


      user1.playlists << playlist
      user2.playlists << playlist
      user3.playlists << playlist

      expect(playlist).to respond_to(:users)
      expect(playlist.users.first.username).to eq(user1.username)
      expect(playlist.users.last.username).to eq(user3.username)
      expect(playlist.users.size).to eq(3)
    end

    it 'cannot have duplicate songs' do
      album1 = Album.create(name: 'spacelounge')
      album2 = Album.create(name: 'dark souls ost')
      song1 = Song.create(name: 'On the Road Again', album_id: album1.id)
      song2 = Song.create(name: 'On the Road Again', album_id: album2.id)
      song3 = Song.create(name: 'Hit the Road Jack', album_id: album1.id)
      playlist = Playlist.new(name: 'Road')

      playlist.songs << song1
      playlist.songs << song2
      playlist.songs << song3
      playlist.songs << song3

      expect(playlist.songs).to eq([song1, song2, song3])
      expect(playlist.songs.size).to eq(3)
    end
  end

  describe 'instance methods' do
    it '.add_song' do
      playlist = Playlist.create(name: 'Road')
      album = Album.create(name: 'spacelounge')
      song = Song.create(name: 'On the Road Again', album_id: album.id)

      playlist.add_song(song.id)

      expect(playlist.songs.size).to eq(1)
      expect(playlist.songs.first).to eq(song)
    end

    it '.remove_song' do
      playlist = Playlist.create(name: 'Road')
      album = Album.create(name: 'spacelounge')
      song = Song.create(name: 'On the Road Again', album_id: album.id)

      playlist.songs << song
      playlist.remove_song(song.id)

      expect(playlist.songs.size).to eq(0)
    end
  end
end
