import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source.dart';
import 'package:senior_instagram/features/data/models/post/post_model.dart';
import 'package:senior_instagram/features/data/models/user/user_model.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:uuid/uuid.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl(
      {required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage});

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseConsts.users);

    final uid = await getCurrentUid();

    userCollection.doc(user.uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        email: user.email,
        uid: uid,
        bio: user.bio,
        profileUrl: user.profileUrl,
        followers: user.followers,
        following: user.following,
        website: user.website,
        username: user.username,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Error: $error");
    });
  }

  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection = firestore.collection(FirebaseConsts.users);

    final uid = await getCurrentUid();

    userCollection.doc(user.uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        email: user.email,
        uid: uid,
        bio: user.bio,
        profileUrl: profileUrl,
        followers: user.followers,
        following: user.following,
        website: user.website,
        username: user.username,
        totalFollowers: user.totalFollowers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Error: $error");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firestore
        .collection(FirebaseConsts.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map(
      (querySnapsoht) {
        return querySnapsoht.docs
            .map((e) => UserModel.fromSnapshot(e))
            .toList();
      },
    );
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firestore.collection(FirebaseConsts.users);
    return userCollection.snapshots().map(
      (querySnapsoht) {
        return querySnapsoht.docs
            .map((e) => UserModel.fromSnapshot(e))
            .toList();
      },
    );
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print("fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.imageFile != null) {
            uploadImageToStorage(user.imageFile, false, "profileImages")
                .then((profileUrl) {
              createUserWithImage(user, profileUrl);
            });
          } else {
            createUserWithImage(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseConsts.users);
    Map<String, dynamic> userInformation = {};

    if (user.username != "" && user.username != null) {
      userInformation["username"] = user.username;
    }
    if (user.name != "" && user.name != null) {
      userInformation["name"] = user.name;
    }
    if (user.bio != "" && user.bio != null) {
      userInformation["bio"] = user.bio;
    }
    if (user.website != "" && user.website != null) {
      userInformation["website"] = user.website;
    }
    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation["profileUrl"] = user.profileUrl;
    }
    if (user.followers != null) {
      userInformation["followers"] = user.followers;
    }
    if (user.following != null) {
      userInformation["following"] = user.following;
    }
    if (user.totalFollowers != null) {
      userInformation["totalFollowers"] = user.totalFollowers;
    }
    if (user.totalFollowing != null) {
      userInformation["totalFollowing"] = user.totalFollowing;
    }
    if (user.totalPosts != null) {
      userInformation["totalPosts"] = user.totalPosts;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firestore.collection(FirebaseConsts.post);

    final newPost = PostModel(
      creatorUid: post.creatorUid,
      postId: post.postId,
      username: post.username,
      userProfileUrl: post.userProfileUrl,
      createAt: post.createAt,
      totalComments: 0,
      totalLikes: 0,
      description: post.description,
      postImageUrl: post.postImageUrl,
      likes: [],
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost);
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      toast("some error occured $e ");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firestore.collection(FirebaseConsts.post);

    try {
      await postCollection.doc(post.postId).delete();
    } catch (e) {
      toast("some error occured $e ");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firestore.collection(FirebaseConsts.post);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    final postCollection = firestore
        .collection(FirebaseConsts.post)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firestore.collection(FirebaseConsts.post);
    Map<String, dynamic> postInfo = Map();

    if (post.description != "" && post.description != null) {
      postInfo['description'] = post.description;
    }
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
    }
    postCollection.doc(post.postId).update(postInfo);
  }
}
