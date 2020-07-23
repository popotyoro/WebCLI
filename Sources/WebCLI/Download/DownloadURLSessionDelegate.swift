//
//  DownloadURLSessionDelegate.swift
//  WebCLI
//
//  Created by popota on 2020/07/18.
//

import Foundation

final class DownloadURLSessionDelegate: NSObject {
    var downloadProgress: ((Progress) -> Void)?
    var downloadResult: ((URLResponse?, URL) -> Void)?
    var downloadDidError: ((Error) -> Void)?
}

extension DownloadURLSessionDelegate: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadResult?(downloadTask.response, location)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress?(downloadTask.progress)
    }
}

extension DownloadURLSessionDelegate: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }
        downloadDidError?(error)
    }
}
