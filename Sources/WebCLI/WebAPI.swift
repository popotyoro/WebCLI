//
//  WebAPI.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public enum WebAPI {
    
    /// Sync Request Default Timeout
    public static let defaultSyncRequestTimeout: Double = 60.0
    
    /// Async Request
    /// - Parameters:
    ///   - request: WebRequest
    ///   - completion: Request Result
    public static func send(request: WebRequest, completion: @escaping (WebReqestResult) -> Void) {
        let urlRequest = request.createURLRequest()
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.connectionError(error: error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            let webResponse = createWebResponse(data: data, response: response)
            completion(.success(webResponse))
        }
        
        task.resume()
    }
    
    /// Sync Request
    /// - Parameters:
    ///   - request: WebRequest
    ///   - timeout: Request timeout
    /// - Returns: Request Result
    public static func syncSend(request: WebRequest, timeout: Double = defaultSyncRequestTimeout) -> (WebReqestResult) {
        let urlRequest = request.createURLRequest()
        let semaphore = DispatchSemaphore(value: 0)
        var result: WebReqestResult = .failure(.noResponse) // defaultはnoResponseにしておく
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            defer {
                semaphore.signal()
            }
            if let error = error {
                result = .failure(.connectionError(error: error))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                result = .failure(.noResponse)
                return
            }
            
            result = .success(createWebResponse(data: data, response: response))
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .now() + defaultSyncRequestTimeout)
        
        return result
    }
}

protocol DownloadRequest {
    
    /// Download Request
    /// - Parameters:
    ///   - request: WebRequest
    ///   - progress: Progress
    ///   - completion: Request Result
    static func download(request: WebRequest,
                         progress: @escaping ((Progress) -> Void),
                         completion: @escaping (WebReqestResult) -> Void) -> URLSessionDownloadTask
    
    /// Download With Using ResumeData
    /// - Parameters:
    ///   - resumeData: ResumeData
    ///   - progress: Progress
    ///   - completion: Request Result
    static func download(withResume resumeData: Data,
                         progress: @escaping ((Progress) -> Void),
                         completion: @escaping (WebReqestResult) -> Void) -> URLSessionDownloadTask
}

extension WebAPI: DownloadRequest {
    
    @discardableResult
    public static func download(request: WebRequest,
                                progress: @escaping ((Progress) -> Void),
                                completion: @escaping (WebReqestResult) -> Void) -> URLSessionDownloadTask {
        
        let downloadURLSessionDelegate = DownloadURLSessionDelegate()
        let urlSession = URLSession(configuration: .default, delegate: downloadURLSessionDelegate, delegateQueue: nil)
        let downloadTask = urlSession.downloadTask(with: request.createURLRequest())
        
        requestDownload(downloadTask: downloadTask,
                        downloadURLSessionDelegate: downloadURLSessionDelegate,
                        urlSession: urlSession,
                        progress: progress,
                        completion: completion)
        
        return downloadTask
    }
    
    @discardableResult
    public static func download(withResume resumeData: Data,
                         progress: @escaping ((Progress) -> Void),
                         completion: @escaping (WebReqestResult) -> Void) -> URLSessionDownloadTask {
        let downloadURLSessionDelegate = DownloadURLSessionDelegate()
        let urlSession = URLSession(configuration: .default, delegate: downloadURLSessionDelegate, delegateQueue: nil)
        let downloadTask = urlSession.downloadTask(withResumeData: resumeData)
        
        requestDownload(downloadTask: downloadTask,
                        downloadURLSessionDelegate: downloadURLSessionDelegate,
                        urlSession: urlSession,
                        progress: progress,
                        completion: completion)
        
        return downloadTask
    }
}

private extension WebAPI {
    static func createWebResponse(data: Data, response: HTTPURLResponse) -> WebResponse {
        var headers: [String: String] = [:]
        response.allHeaderFields.forEach { (key, value) in
            headers[key.description] = String(describing: value)
        }
        
        return WebResponse(
            statusCode: HTTPStatus(statusCode: response.statusCode),
            headers: headers,
            body: data
        )
    }
    
    static func requestDownload(downloadTask: URLSessionDownloadTask,
                                downloadURLSessionDelegate: DownloadURLSessionDelegate,
                                urlSession: URLSession,
                                progress: @escaping ((Progress) -> Void),
                                completion: @escaping (WebReqestResult) -> Void) {
        
        downloadURLSessionDelegate.downloadProgress = { _progress in
            progress(_progress)
        }
        downloadURLSessionDelegate.downloadResult = {(response, url) in
            defer { urlSession.invalidateAndCancel() }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                completion(.success(createWebResponse(data: data, response: response)))
            } catch {
                completion(.failure(.parseError(error: error)))
            }
        }
        downloadURLSessionDelegate.downloadDidError = { error in
            defer { urlSession.invalidateAndCancel() }
            completion(.failure(.connectionError(error: error)))
        }
        
        downloadTask.resume()
    }
}
