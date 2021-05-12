package com.example.challengewithfriends

import android.app.Activity.RESULT_OK
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.provider.MediaStore.Images.Media.getBitmap
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import androidx.annotation.RequiresApi
import androidx.core.graphics.blue
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.util.*

class UploadFragment : Fragment() {
    private lateinit var submit:Button
    private lateinit var select:Button
    private lateinit var imageView: ImageView
    private var imageURI: Uri? = null
    private val client = OkHttpClient()
    private var challengeID: Int =0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            challengeID= it.getInt("challenge_id")
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val root:View= inflater.inflate(R.layout.fragment_upload, container, false)
        submit=root.findViewById(R.id.submit_upload)
        submit.visibility=View.GONE
        select=root.findViewById(R.id.select)
        imageView=root.findViewById(R.id.upload_imageview)
        select.setOnClickListener(){
            // get pic from internal storage
            val gallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI)
            startActivityForResult(gallery,100) //100 = request code?
            submit.visibility=View.VISIBLE
        }
        submit.setOnClickListener(){
            // encode as b64 and send
            val bitmap:Bitmap = MediaStore.Images.Media.getBitmap(activity?.contentResolver,imageURI)
            val baos:ByteArrayOutputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG,100,baos)
            val b:ByteArray = baos.toByteArray()
            var encodedImage:String = Base64.getEncoder().encodeToString(b)
            encodedImage="data:image/png;base64,"+encodedImage
            postPic(encodedImage, challengeID)
            fragmentManager?.beginTransaction()
                    ?.remove(this)
                    ?.commit()
        }
        return root
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == RESULT_OK && requestCode == 100){
            imageURI=data?.data
            imageView.setImageURI(imageURI)
        }
    }

    private fun postPic(encodedImage:String, challengeID:Int){
        CoroutineScope(Dispatchers.Main).launch {
            val json = "application/json; charset=utf-8".toMediaType()
//            Log.d("tag1","{\"challenge_id\":\"$challengeID\",\"image_data\":\"${encodedImage.subSequence(0,50)}\"}")
            val body = "{\"challenge_id\":\"$challengeID\",\"image_data\":\"$encodedImage\"}".toRequestBody(json)
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/challenges/mark_completed/")
                    .post(body)
                    .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                }
            }
        }
    }

    companion object {
        @JvmStatic
        fun newInstance(challengeID: Int) =
            UploadFragment().apply {
                arguments = Bundle().apply {
                    putInt("challenge_id",challengeID)
                }
            }
    }
}