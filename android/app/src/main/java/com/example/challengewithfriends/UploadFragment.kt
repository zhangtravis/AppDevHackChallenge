package com.example.challengewithfriends

import android.app.Activity.RESULT_OK
import android.content.Intent
import android.os.Bundle
import android.provider.MediaStore
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView

class UploadFragment : Fragment() {
    private lateinit var submit:Button
    private lateinit var select:Button
    private lateinit var imageView: ImageView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {

        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val root:View= inflater.inflate(R.layout.fragment_upload, container, false)
        submit=root.findViewById(R.id.submit_upload)
        select=root.findViewById(R.id.select)
        imageView=root.findViewById(R.id.upload_imageview)
        select.setOnClickListener(){
            // get pic from internal storage
            val gallary = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI)
            startActivityForResult(gallary,100) //100 = request code?
        }
        submit.setOnClickListener(){
            // encode as b64 and send
        }
        return root
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == RESULT_OK && requestCode == 100){
            imageView.setImageURI(data?.data)
        }
    }

    companion object {
        @JvmStatic
        fun newInstance() =
            UploadFragment().apply {
                arguments = Bundle().apply {

                }
            }
    }
}