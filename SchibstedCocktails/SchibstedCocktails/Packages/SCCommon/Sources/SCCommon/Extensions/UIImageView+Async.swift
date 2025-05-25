//
//  UIImageView+Async.swift
//  SCCommon
//
//  Created by Uladzislau Makei on 24.05.25.
//

import UIKit

public actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    func image(forKey key: NSURL) -> UIImage? {
        cache.object(forKey: key)
    }

    func insertImage(_ image: UIImage, forKey key: NSURL) {
        cache.setObject(image, forKey: key)
    }
}

@MainActor
public extension UIImageView {

    private class AssociatedKeys {
        // static var is mutable, which is required to get its address safely
        @MainActor static var imageLoadTaskKey = 0
    }

    private var currentTask: Task<Void, Never>? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.imageLoadTaskKey) as? Task<Void, Never>
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.imageLoadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(from url: URL, placeholder: UIImage? = nil) {
        currentTask?.cancel()
        self.image = placeholder

        let task = Task { [weak self] in
            guard let self = self else { return }
            if let cached = await ImageCache.shared.image(forKey: url as NSURL) {
                self.image = cached
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                if let image = UIImage(data: data) {
                    await ImageCache.shared.insertImage(image, forKey: url as NSURL)
                    self.image = image
                }
            } catch {
                // ignore or handle error
            }
        }

        currentTask = task
    }
}
