#ifndef COMMENTMODEL_H
#define COMMENTMODEL_H

#include "abstractlistmodelmanager.h"
#include "commentobject.h"
#include "votemanager.h"

class CommentModel : public AbstractListModelManager
{
    Q_OBJECT
    Q_ENUMS(SortType)
    Q_PROPERTY(QString permalink READ permalink WRITE setPermalink NOTIFY permalinkChanged)
    Q_PROPERTY(SortType sort READ sort WRITE setSort NOTIFY sortChanged)
public:
    enum Roles {
        FullnameRole = Qt::UserRole,
        AuthorRole,
        BodyRole,
        ScoreRole,
        LikesRole,
        CreatedRole,
        DepthRole,
        IsScoreHiddenRole,
        IsValidRole
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

    QString permalink() const;
    void setPermalink(const QString &permalink);

    SortType sort() const;
    void setSort(SortType sort);

    // C++ functions
    void changeVote(const QString &fullname, VoteManager::VoteType voteType);
    void insertComment(CommentObject comment, const QString &replyToFullname);

    // QML functions
    void refresh(bool refreshOlder);
    Q_INVOKABLE int getParentIndex(int index) const;

protected:
    QHash<int, QByteArray> customRoleNames() const;

signals:
    void permalinkChanged();
    void sortChanged();
    void commentLoaded();

private slots:
    void onNetworkReplyReceived(QNetworkReply *reply);
    void onFinished();

private:
    QString m_permalink;
    SortType m_sort;

    QList<CommentObject> m_commentList;
    QNetworkReply *m_reply;

    static QString getSortString(SortType sort);
};

#endif // COMMENTMODEL_H
