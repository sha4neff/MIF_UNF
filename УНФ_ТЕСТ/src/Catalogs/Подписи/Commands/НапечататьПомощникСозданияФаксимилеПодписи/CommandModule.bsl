#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	СтруктураДополнительныхПараметров = Новый Структура("ЗаголовокФормы", НСтр(
		"ru ='Инструкция ""Как создать факсимиле подписи""'"));

	ПараметрыКомандыПечати = Новый Массив;
	ПараметрыКомандыПечати.Добавить(ПараметрКоманды);

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Подписи", "НапечататьПомощникСозданияФаксимилеПодписи",
		ПараметрыКомандыПечати, ПараметрыВыполненияКоманды, СтруктураДополнительныхПараметров);

КонецПроцедуры

#КонецОбласти
