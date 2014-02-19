/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

#ifndef COMMENTMODEL_H
#define COMMENTMODEL_H

#include "abstractlistmodelmanager.h"
#include "commentobject.h"

class CommentModel : public AbstractListModelManager
{
    Q_OBJECT
    Q_ENUMS(SortType)
    Q_PROPERTY(QVariant link READ link WRITE setLink NOTIFY linkChanged)
    Q_PROPERTY(QString permalink READ permalink WRITE setPermalink NOTIFY permalinkChanged)
    Q_PROPERTY(SortType sort READ sort WRITE setSort NOTIFY sortChanged)
    Q_PROPERTY(bool commentPermalink READ isCommentPermalink WRITE setCommentPermalink NOTIFY commentPermalinkChanged)
public:
    enum Roles {
        FullnameRole = Qt::UserRole,
        AuthorRole,
        BodyRole,
        RawBodyRole,
        ScoreRole,
        LikesRole,
        CreatedRole,
        DepthRole,
        IsScoreHiddenRole,
        IsValidRole,
        IsAuthorRole,
        VisibilityRole
    };

    enum SortType {
        ConfidenceSort, // a.k.a. "best"
        TopSort,
        NewSort,
        HotSort,
        ControversialSort,
        OldSort
    };

    explicit CommentModel(QObject *parent = 0);

    void classBegin();
    void componentComplete();

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;

    QVariant link() const;
    void setLink(const QVariant &link);

    QString permalink() const;
    void setPermalink(const QString &permalink);

    SortType sort() const;
    void setSort(SortType sort);

    bool isCommentPermalink() const;
    void setCommentPermalink(bool commentPermalink);

    // C++ functions
    void insertComment(CommentObject comment, const QString &replyToFullname);
    void editComment(CommentObject comment);
    void deleteComment(const QString &fullname);

    // QML functions
    void refresh(bool refreshOlder);
    Q_INVOKABLE int getParentIndex(int index) const;
    Q_INVOKABLE int getRootIndex(int index) const;
    Q_INVOKABLE int getNextIndex(int index) const;
    Q_INVOKABLE int getPrevIndex(int index) const;
    Q_INVOKABLE void changeLinkLikes(const QString &fullname, int likes);
    Q_INVOKABLE void changeLikes(const QString &fullname, int likes);

    Q_INVOKABLE void collapse(int index);

protected:
    QHash<int, QByteArray> customRoleNames() const;

signals:
    void linkChanged();
    void permalinkChanged();
    void sortChanged();
    void commentPermalinkChanged();
    void commentLoaded();

private slots:
    void onNetworkReplyReceived(QNetworkReply *reply);
    void onFinished();

private:
    QVariant m_link;
    QString m_permalink;
    SortType m_sort;
    bool m_commentPermalink;

    QList<CommentObject> m_commentList;
    QNetworkReply *m_reply;

    static QString getSortString(SortType sort);
    QList<int> getChildren(int index);
};

#endif // COMMENTMODEL_H
